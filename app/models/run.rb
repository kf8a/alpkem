# frozen_string_literal: true

# Main model in this app. Runs represent a set of measurements
class Run < ActiveRecord::Base
  belongs_to :sample_type
  has_many :measurements, dependent: :delete_all
  has_many :samples, -> { distinct }, through: :measurements
  has_many :analytes, -> { distinct.order("name") }, through: :measurements
  has_many :data_sources

  validates :sample_type_id, presence: true
  validates :measurements,   presence: true

  def approved_samples
    samples.collect do |sample|
      sample if sample.approved?
    end.compact.size
  end

  def self.runs
    all_runs = Run.order("id desc").
    all_runs.reject(&:cn_run?)
  end

  def self.cn_runs
    all_runs = Run.order("id desc").to_a
    all_runs.keep_if(&:cn_run?)
  end

  def all_measurements
    measurements.includes(:sample).includes(:analyte)
  end

  # def analytes
  #   measurements.joins(:analyte).uniq.order(:name)
  # end

  def sample_type_name
    sample_type.name
  end

  # TODO: I need to include the CN designation on the run instead of the sample type
  def cn_run?
    sample_type_name.include?("CN")
  end

  def updated?
    samples.index(&:updated?)
  end

  def complete?
    approved_samples == samples.size
  end

  def sample_date_range
    dates = samples.collect(&:sample_date)
    if dates.min == dates.max
      dates.min.to_s
    else
      "#{dates.min} - #{dates.max}"
    end
  end

  def load_file(_file)
    # at this point I should have a data_source already
    ActiveRecord::Base.transaction do
      parser.parse_file(data_sources[0].data.current_path)
      self.measurements = parser.measurements
      load_errors.blank?
    end
  end

  def parser
    @parser ||= Parsers::Parser.for(sample_type_id, sample_date)
  end

  def load_errors
    short_errors(parser.load_errors)
  end

  def plot_errors
    short_errors(parser.plot_errors)
  end

  def short_errors(errors)
    errors = "#{errors[0..1024]}  ..." if errors.length > 1024
    errors
  end
end
