module Parsers
  #Standard parser to convert files to measurements.
  class StandardParser < FileParser

    def parse_data(data)
      line_parser_name = FileFormatSelector.new.get_line_parser_prefix(data) + 'StandardLineParser'

      data.each { | line | process_line(line, line_parser_name.constantize) }
      if self.measurements.blank?
        self.load_errors += "No data was able to be loaded from this file."
      end
    end

    def process_line(line, line_parser)
      first, second, nh4_amount, no3_amount, raw_sample_date, modifier, site = line_parser.parse(line)
      if raw_sample_date
        self.sample_date = raw_sample_date
      end
      unless first.blank? || second.blank?
        plot_name = get_plot_name(first, second, modifier, site)
        unless plot.try(:name) == plot_name
          find_plot(plot_name) 
        end
        process_nhno_sample(nh4_amount, no3_amount) if plot.present?
      end
    end


    def get_plot_name(first, second, modifier, site )
      if [2,16].include?(@sample_type_id)
        # make_lter_plot(first, second, modifier, site)
        make_plot_with_prefix('T',first, second, modifier, site)
      elsif first.start_with?('L0', 'M0')
        make_scaleup_plot(first, second, modifier, site)
      else
        make_plot_with_prefix('G',first, second, modifier, site)
      end
    end

    private

    def make_lter_plot(first, second, modifier, site )
      if first =~ /^[A-Za-z]/
        "#{first}R#{second}"
      else
        "T#{first}R#{second}"
      end
    end

    def make_plot_with_prefix(prefix, first, second, modifier, site)
      result = if first =~ /^[A-Za-z]/
                 "#{first}R#{second}"
               else
                 "#{prefix}#{first}R#{second}"
               end
      if modifier
        result = result + "-#{modifier}" 
      end
      if site 
        result = "#{site}-" + result
      end
      result
    end

    def make_scaleup_plot(first, second, modifier, site)
      "#{first}S#{second}"
    end
  end
end
