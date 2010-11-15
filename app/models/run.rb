class Run < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy
  has_many :cn_measurements, :dependent => :destroy

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
    20.times do |number|
      unless sample_type_id_to_name(number) == "Unknown Sample Type"
        sample_type_options += [[sample_type_id_to_name(number), "#{number}"]]
      end
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

  def samples
    Sample.where('id in (select sample_id from measurements where run_id = ?)', self.id)
  end

  def sample_by_id(id)
    samples.where(:id => id).first
  end

  def analytes
    if cn_run?
      [Analyte.find_by_name('N'),   Analyte.find_by_name('C')]
    else
      [Analyte.find_by_name('NH4'), Analyte.find_by_name('NO3')]
    end
  end
  
  def updated?
    samples.collect {|x| x.updated_at > x.created_at}.uniq.include?(true)
  end

  def load_file(file)
    @parser = FileParser.for(sample_type_id, sample_date)
    
    # @parser_type = FileParser.for(self.sample_type_id)
    # if @parser_type
    #   @parser = @parser_type.new(self.sample_date, self.sample_type_id)
    if @parser
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
