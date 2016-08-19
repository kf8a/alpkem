require "parsers/file_parser.rb"
require "parsers/cn_sample_parser.rb"
require "parsers/nh4_lysimeter_line_parser.rb"
require "parsers/no3_lysimeter_line_parser.rb"
require "parsers/old_lysimeter_line_parser.rb"
require "parsers/lysimeter_line_parser.rb"
require "parsers/nh4_standard_line_parser.rb"
require "parsers/no3_standard_line_parser.rb"
require "parsers/old_standard_line_parser.rb"
require "parsers/cn_glbrc_generic_parser.rb"
require "parsers/cn_glbrc_parser.rb"
require "parsers/generic_line_parser.rb"
require "parsers/generic_parser.rb"
require "parsers/glbrc_cn_deep_core_parser.rb"
require "parsers/glbrc_cn_plant_parser.rb"
require "parsers/glbrc_deep_parser.rb"
require "parsers/glbrc_scaleup_base_parser.rb"
require "parsers/glbrc_switchgrass_cn_parser.rb"
require "parsers/leilei_sample_parser.rb"
require "parsers/lter_cn_deep_parser.rb"
require "parsers/lter_cn_deep_horizon_parser.rb"
require "parsers/lter_cn_plant_parser.rb"
require "parsers/lter_soil_parser.rb"
require "parsers/lysimeter_parser.rb"
require "parsers/resource_gradient_parser.rb"
require "parsers/standard_line_parser.rb"
require "parsers/standard_parser.rb"
require "parsers/cn_deep_parser.rb"
require "parsers/glbrc_cn_soil_parser.rb"
# require "parsers/cimmyt_parser.rb"

module Parsers
  class Parser
    def self.for(sample_type_id,date)
      klass = case sample_type_id
              when 1; Parsers::LysimeterParser
              when 2; Parsers::StandardParser #LterSoilParser
              when 3; Parsers::StandardParser
              when 4; Parsers::GLBRCDeepParser
              when 5; Parsers::StandardParser
              when 6; Parsers::CNSampleParser
              when 7; Parsers::CNDeepParser  # deprecated old deepcore parser
              when 8; Parsers::StandardParser # glbrc inorganic N 0-25 deprecated
              when 9; Parsers::CNGLBRCParser
              when 10; Parsers::LysimeterNO3Parser
              when 11; Parsers::LysimeterNH4Parser
              when 12; Parsers::GLBRCCNPlantParser #GLBRC Plants (ANPP)
              when 13; Parsers::LeileiSampleParser
              when 14; Parsers::LterCnPlantParser #LTER CN PLants
              when 15; Parsers::LterCnDeepHorizonParser #LTER CN Deep  deprecated
              when 16; Parsers::StandardParser  #LterSoilParser
              when 17; Parsers::GLBRCScaleupBaseParser #Baseline 2009 scaleup samples deprecated
                # when 18; Parsers::SWFParser
              when 19; Parsers::GenericParser   #T28 glbrc mineralization data
              when 20; Parsers::GenericParser   #glbrc soil data
              when 21; Parsers::GenericParser   #glbrc scaleup soil N
              when 22; Parsers::ResourceGradientParser
              when 23; Parsers::GLBRCSwitchgrassCNParser
              when 24; Parsers::GenericParser   #T0 glbrc mineralization
              when 25; Parsers::CNGLBRCGenericParser  #Annual Root CN
              when 26; Parsers::GLBRCCNDeepCoreParser  #GLBRC Deep cors
              when 27; Parsers::LterCnPlantParser   #LTER Post frost
              when 28; Parsers::LterCnPlantParser
              when 29; Parsers::GLBRCCNPlantParser # GLBRC Harvest CN (grab sample)
              when 30; Parsers::LterCnDeepParser #LTER CN Deep (new format)
              # when 31: Parsers::CIMMYParser #lachat CIMMYT samples
              when 32; Parsers::GLBRCCNDeepCoreParser  #GLBRC Deep cores Marginal Land site
              when 33; Parsers::StandardParser #Lachat switchgrass (mineralization? samples T0)
              when 34; Parsers::StandardParser #Lachat switchgrass (mineralization? samples T28)
              when 35; Parsers::GLBRCCNSoilParser # GLBRC soil samples new format
              when 36; Parsers::GLBRCCNPlantParser # GLBRC Harvest Plant Residue collection (raked from the ground in frames)
              when 37; Parsers::GLBRCSwitchgrassCNParser # GLBRC Switchgrass Soil
              else false
              end

      klass.new(date, sample_type_id) if klass
    end
  end
end
