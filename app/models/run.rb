#Main model in this app. Runs represent a set of measurements taken at one time.
class Run < ActiveRecord::Base
  belongs_to :sample_type
  has_many :measurements, dependent: :delete_all
  has_many :samples, -> {uniq},  through: :measurements #, dependent: :destroy
  has_many :analytes, -> {uniq.order('name')}, through: :measurements
  has_many :data_sources

  validates :sample_type_id, presence: true
  validates :measurements,   presence: true

  def approved_samples
    samples.collect do |sample|
      sample if sample.approved?
    end.compact.size
  end

  def self.runs
    all_runs = Run.order('id desc').to_a
    all_runs.keep_if {|run| !run.cn_run?}
  end

  def self.cn_runs
    all_runs = Run.order('run_date').to_a
    all_runs.keep_if {|run| run.cn_run?}
  end

  def all_measurements
    self.measurements.includes(:sample).includes(:analyte)
  end

  # def analytes
  #   measurements.joins(:analyte).uniq.order(:name)
  # end

  def similar_runs
    Run.where(:sample_date => sample_date, :sample_type_id => sample_type_id)
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

  def complete?
    approved_samples == samples.size
  end

  def sample_date_range
    dates = samples.collect {|x| x.sample_date }
    if dates.min == dates.max
      "#{dates.min}"
    else
      "#{dates.min} - #{dates.max}"
    end
  end

  def load_file(file)
    ActiveRecord::Base.transaction do
      parser.parse_file(file)
      self.measurements = parser.measurements
      self.load_errors.blank?
    end
  end

  def parser
    @parser ||= Parsers::Parser.for(sample_type_id, sample_date)
  end

  def load_errors
    errors = parser.load_errors
    if errors.length > 1024
      errors = errors[0..1024] + "..."
    end
    errors
  end

  def plot_errors
    errors = parser.plot_errors
    if errors.length > 1024
      errors = errors[0..1024] + "..."
    end
    errors
  end

  def update_sample_types
   samples.each do |sample|
     sample.sample_type_id = sample_type_id
     sample.save
   end
  end
end
