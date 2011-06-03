#Main model in this app. Runs represent a set of measurements taken at one time.
class Run < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy
  has_many :cn_measurements, :dependent => :destroy
  has_many :samples, :through => :measurements, :uniq => true
  has_many :analytes, :through => :measurements, :uniq => true

  validates :sample_type_id, :presence => true
  validates :measurements,   :presence => true

  def self.runs
    all_runs = Run.order('sample_date')
    all_runs.keep_if {|run| !run.cn_run?}
  end

  def self.cn_runs
    all_runs = Run.order('run_date')
    all_runs.keep_if {|run| run.cn_run?}
  end

  def self.sample_type_options
    sample_type_options = []
    number = 1
    until sample_type_id_to_name(number) == "Unknown Sample Type"
      sample_type_options += [[sample_type_id_to_name(number), "#{number}"]]
      number += 1
    end
    sample_type_options
  end

  def self.sample_type_id_to_name(id)
    case id
    when  1; "Lysimeter"
    when  2; "Soil Sample"
    when  3; "GLBRC Soil Sample"
    when  4; "GLBRC Deep Core Nitrogen"
    when  5; "GLBRC Resin Strips"
    when  6; "CN Soil Sample"
    when  7; "CN Deep Core"
    when  8; "GLBRC Soil Sample (New)"
    when  9; "GLBRC CN"
    when 10; "Lysimeter NO3"
    when 11; "Lysimeter NH4"
    when 12; "GLBRC CN Plant"
    when 13; 'Leilei Samples NO3 NH4'
    else    "Unknown Sample Type"
    end
  end

  def sample_type_name
    Run.sample_type_id_to_name(self.sample_type_id)
  end

  def cn_run?
    self.sample_type_name.include?("CN")
  end

  def updated?
    samples.index {|sample| sample.updated?}
  end

  def load_file(file)
    parser.parse_file(file)
    self.measurements = parser.measurements
    self.load_errors.blank?
  end

  def parser
    @parser ||= FileParser.for(sample_type_id, sample_date)
  end

  def load_errors
    parser.load_errors
  end

  def plot_errors
    parser.plot_errors
  end
end
