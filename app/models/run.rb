#Main model in this app. Runs represent a set of measurements taken at one time.
class Run < ActiveRecord::Base
  belongs_to :sample_type
  has_many :measurements, :dependent => :destroy
  has_many :samples, :through => :measurements, :uniq => true
  has_many :analytes, :through => :measurements, :uniq => true

  validates :sample_type_id, :presence => true
  validates :measurements,   :presence => true

  def self.runs
    all_runs = Run.order('sample_date')
    all_runs.keep_if {|run| !run.cn_run?}
  end

  def self.cn_runs
    all_runs = Run.order('sample_date')
    all_runs.keep_if {|run| run.cn_run?}
  end

  def all_measurements
    self.measurements.includes(:sample).includes(:analyte)
  end

  def sample_type_name
    self.sample_type.name
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
