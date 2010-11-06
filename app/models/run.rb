require 'file_parser'

class Run < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy
  has_many :cn_measurements, :dependent => :destroy

  validates :sample_type_id, :presence => true
  validates :measurements, :presence => { :unless => :cn_measurements_exist? }

  def self.runs
    all_runs = Run.order('sample_date')
    runs_index = []
    all_runs.each do |run|
      runs_index << run unless run.cn_measurements_exist?
    end
    runs_index
  end

  def self.cn_runs
    all_runs = Run.order('sample_date')
    runs_index = []
    all_runs.each do |run|
      runs_index << run if run.cn_measurements_exist?
    end
    runs_index
  end

  def measurement_by_id(id)
    measurements.where(:id => id).first || cn_measurements.where(:id => id).first
  end

  def sample_by_id(id)
    samples.where(:id => id).first
  end

  def cn_measurements_exist?
    !cn_measurements.blank?
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.find_all_by_analyte_id(analyte.id)
  end
  
  def analytes
    if cn_measurements_exist?
      [Analyte.find_by_name('N'),   Analyte.find_by_name('C')]
    else
      [Analyte.find_by_name('NH4'), Analyte.find_by_name('NO3')]
    end
  end
  
  def samples
    if cn_measurements_exist?
      CnSample.where('id in (select cn_sample_id from cn_measurements where run_id = ?)', self.id)
    else
      Sample.where('id in (select sample_id from measurements where run_id = ?)', self.id)
    end
  end
    
  def updated?
    samples.collect {|x| x.updated_at > x.created_at}.uniq.include?(true)
  end

  def sample_type_name(id=sample_type_id)
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
  
  def load_file(file)
    @parser = FileParser.new(self.sample_date, self.sample_type_id)
    @parser.parse_file(file)
    @parser.measurements.each {|measurement| self.measurements << measurement}
    @parser.cn_measurements.each {|measurement| self.cn_measurements << measurement}
    self.load_errors.blank?
  end

  def load_errors
    @parser.try(:load_errors) || ""
  end

  def plot_errors
    @parser.try(:plot_errors) || ""
  end
end
