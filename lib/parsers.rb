require 'parsers/file_parser.rb'
require 'parsers/cn_sample_parser.rb'
require 'parsers/nh4_lysimeter_line_parser.rb'
require 'parsers/no3_lysimeter_line_parser.rb'
require 'parsers/old_lysimeter_line_parser.rb'
require 'parsers/lysimeter_line_parser.rb'
require 'parsers/nh4_standard_line_parser.rb'
require 'parsers/no3_standard_line_parser.rb'
require 'parsers/old_standard_line_parser.rb'
require 'parsers/cn_glbrc_generic_parser.rb'
require 'parsers/cn_glbrc_parser.rb'
require 'parsers/generic_line_parser.rb'
require 'parsers/generic_parser.rb'
require 'parsers/glbrc_cn_deep_core_parser.rb'
require 'parsers/glbrc_cn_plant_parser.rb'
require 'parsers/glbrc_deep_parser.rb'
require 'parsers/glbrc_scaleup_base_parser.rb'
require 'parsers/glbrc_switchgrass_cn_parser.rb'
require 'parsers/leilei_sample_parser.rb'
require 'parsers/lter_cn_deep_parser.rb'
require 'parsers/lter_cn_deep_horizon_parser.rb'
require 'parsers/lter_cn_plant_parser.rb'
require 'parsers/lter_soil_parser.rb'
require 'parsers/lysimeter_parser.rb'
require 'parsers/resource_gradient_parser.rb'
require 'parsers/standard_line_parser.rb'
require 'parsers/standard_parser.rb'
require 'parsers/cn_deep_parser.rb'
require 'parsers/glbrc_cn_soil_parser.rb'
# require 'parsers/cimmyt_parser.rb'

module Parsers
  class Parser
    def self.for(sample_type_id,date)
      klass = case sample_type_id
              when 1 then Parsers::LysimeterParser
              when 2 then Parsers::StandardParser # LterSoilParser
              when 3 then Parsers::StandardParser
              when 4 then Parsers::GLBRCDeepParser
              when 5 then Parsers::StandardParser
              when 6 then Parsers::CNSampleParser
              when 7 then Parsers::CNDeepParser  # deprecated old deepcore parser
              when 8 then Parsers::StandardParser # glbrc inorganic N 0-25 deprecated
              when 9 then Parsers::CNGLBRCParser
              when 10 then Parsers::LysimeterNO3Parser
              when 11 then Parsers::LysimeterNH4Parser
              when 12 then Parsers::GLBRCCNPlantParser # GLBRC Plants (ANPP)
              when 13 then Parsers::LeileiSampleParser
              when 14 then Parsers::LterCnPlantParser # LTER CN PLants
              when 15 then Parsers::LterCnDeepHorizonParser # LTER CN Deep  deprecated
              when 16 then Parsers::StandardParser # LterSoilParser
              when 17 then Parsers::GLBRCScaleupBaseParser # Baseline 2009 scaleup samples deprecated
                # when 18 then Parsers::SWFParser
              when 19 then Parsers::GenericParser   # T28 glbrc mineralization data
              when 20 then Parsers::GenericParser   # glbrc soil data
              when 21 then Parsers::GenericParser   # glbrc scaleup soil N
              when 22 then Parsers::ResourceGradientParser
              when 23 then Parsers::GLBRCSwitchgrassCNParser
              when 24 then Parsers::GenericParser   # T0 glbrc mineralization
              when 25 then Parsers::CNGLBRCGenericParser # Annual Root CN
              when 26 then Parsers::GLBRCCNDeepCoreParser # GLBRC Deep cors
              when 27 then Parsers::LterCnPlantParser # LTER Post frost
              when 28 then Parsers::LterCnPlantParser
              when 29 then Parsers::GLBRCCNPlantParser # GLBRC Harvest CN (grab sample)
              when 30 then Parsers::LterCnDeepParser # LTER CN Deep (new format)
              # when 31: Parsers::CIMMYParser #lachat CIMMYT samples
              when 32 then Parsers::GLBRCCNDeepCoreParser #GLBRC Deep cores Marginal Land site
              when 33 then Parsers::StandardParser # Lachat switchgrass (mineralization? samples T0)
              when 34 then Parsers::StandardParser # Lachat switchgrass (mineralization? samples T28)
              when 35 then Parsers::GLBRCCNSoilParser # GLBRC soil samples new format
              when 36 then Parsers::GLBRCCNPlantParser # GLBRC Harvest Plant Residue collection (raked from the ground in frames)
              when 37 then Parsers::GLBRCSwitchgrassCNParser # GLBRC Switchgrass Soil
              when 38 then Parsers::LysimeterParser # Rainout shelters
              else false
              end

      klass.new(date, sample_type_id) if klass
    end
  end
end
