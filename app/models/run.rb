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
    all_runs = Run.order('sample_date')
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
    else    "Unknown Sample Type"
    end
  end

  def sample_type_name
    Run.sample_type_id_to_name(self.sample_type_id)
  end

  def cn_run?
    self.sample_type_name.include?("CN")
  end

  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.find_all_by_analyte_id(analyte.id)
  end

  def measurement_by_id(id)
    measurements.find_by_id(id)
  end

  def sample_by_id(id)
    samples.find_by_id(id)
  end

  def updated?
    samples.collect {|sample| sample.updated?}.include?(true)
  end

  def load_file(file)
    @parser_type = FileParser.for(self.sample_type_id)
    if @parser_type
      @parser = @parser_type.new(self.sample_date, self.sample_type_id)
      @parser.parse_file(file)
      @parser.measurements.each {|measurement| self.measurements << measurement}
      self.load_errors.blank?
    end
  end

  def load_errors
    @parser.try(:load_errors) || ""
  end

  def plot_errors
    @parser.try(:plot_errors) || ""
  end
end
