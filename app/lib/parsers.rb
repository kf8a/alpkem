# frozen_string_literal: true

require "parsers/file_parser"
require "parsers/c_n_sample_parser"
require "parsers/n_h4_lysimeter_line_parser"
require "parsers/n_o3_lysimeter_line_parser"
require "parsers/old_lysimeter_line_parser"
require "parsers/lysimeter_line_parser"
require "parsers/n_h4_standard_line_parser"
require "parsers/n_o3_standard_line_parser"
require "parsers/old_standard_line_parser"
require "parsers/c_n_g_l_b_r_c_generic_parser"
require "parsers/cn_glbrc_parser"
require "parsers/generic_line_parser"
require "parsers/generic_parser"
require "parsers/glbrc_cn_deep_core_parser"
require "parsers/glbrc_cn_plant_parser"
require "parsers/glbrc_deep_parser"
require "parsers/glbrc_scaleup_base_parser"
require "parsers/glbrc_switchgrass_cn_parser"
require "parsers/leilei_sample_parser"
require "parsers/lter_cn_deep_parser"
require "parsers/lter_cn_deep_horizon_parser"
require "parsers/lter_cn_plant_parser"
require "parsers/lter_soil_parser"
require "parsers/lysimeter_parser"
require "parsers/resource_gradient_parser"
require "parsers/standard_line_parser"
require "parsers/standard_parser"
require "parsers/cn_deep_parser"
require "parsers/glbrc_cn_soil_parser"
require "parsers/glbrc_cn_pit_parser"
require "parsers/glbrc_cn_root_soil_parser"
require "parsers/glbrc_cn_pit_root_parser"
require "parsers/glbrc_cn_root_excavation_soil_parser"
require "parsers/glbrc_cn_root_excavation_plant_parser"
require "parsers/m_l_e_soil_parser"
# require "parsers/cimmyt_parser"

module Parsers
  class Parser
    def self.for(sample_type_id,date)
      klass = case sample_type_id
              when 1 then Parsers::LysimeterParser
              when 2 then Parsers::GenericParser # LterSoilParser
              # when 3 then Parsers::StandardParser # deprecated
              when 4 then Parsers::GlbrcDeepParser
              # when 5 then Parsers::StandardParser # deprecated
              when 6 then Parsers::CNSampleParser
              when 7 then Parsers::CnDeepParser # deprecated old deepcore parser
              # when 8 then Parsers::StandardParser # deprecated glbrc inorganic N 0-25
              when 9 then Parsers::CNGlbrcParser
              when 10 then Parsers::LysimeterNO3Parser
              when 11 then Parsers::LysimeterNH4Parser
              when 12 then Parsers::GlbrcCnPlantParser # GLBRC Plants (ANPP)
              when 13 then Parsers::LeileiSampleParser
              when 14 then Parsers::LterCnPlantParser # LTER CN PLants
              when 15 then Parsers::LterCnDeepHorizonParser # LTER CN Deep  deprecated
              when 16 then Parsers::GenericParser # LterSoilParser 21 day incubation
              when 17 then Parsers::GlbrcScaleupBaseParser # Baseline 2009 scaleup samples deprecated
                # when 18 then Parsers::SWFParser
              when 19 then Parsers::GenericParser   # T28 glbrc mineralization data
              when 20 then Parsers::GenericParser   # glbrc soil data
              when 21 then Parsers::GenericParser   # glbrc scaleup soil N
              when 22 then Parsers::ResourceGradientParser
              when 23 then Parsers::GlbrcSwitchgrassCnParser
              when 24 then Parsers::GenericParser   # T0 glbrc mineralization
              when 25 then Parsers::CNGLBRCGenericParser # Annual Root CN
              when 26 then Parsers::GlbrcCnDeepCoreParser # GLBRC Deep cors
              when 27 then Parsers::LterCnPlantParser # LTER Post frost
              when 28 then Parsers::LterCnPlantParser
              when 29 then Parsers::GlbrcCnPlantParser # GLBRC Harvest CN (grab sample)
              when 30 then Parsers::LterCnDeepParser # LTER CN Deep (new format)
              # when 31: Parsers::CIMMYParser #lachat CIMMYT samples
              when 32 then Parsers::GlbrcCnDeepCoreParser # GLBRC Deep cores Marginal Land site
              when 33 then Parsers::StandardParser # Lachat switchgrass (mineralization? samples T0)
              when 34 then Parsers::StandardParser # Lachat switchgrass (mineralization? samples T28)
              when 35 then Parsers::GlbrcCnSoilParser # GLBRC soil samples new format
              when 36 then Parsers::GlbrcCnPlantParser # GLBRC Harvest Plant Residue collection (raked from the ground in frames)
              when 37 then Parsers::GlbrcSwitchgrassCnParser # GLBRC Switchgrass Soil
              when 38 then Parsers::LysimeterParser # Rainout shelters
              when 39 then Parsers::GlbrcCnPitParser # MLE pit samples
              when 40 then Parsers::GlbrcCnRootSoilParser # GLBRC Root Soil samples
              when 42 then Parsers::GlbrcCnPitRootParser # GLBRC Root pit samples
              when 43 then Parsers::GlbrcCnRootExcavationSoilParser # GLBRC root excavation soil pit samples
              when 44 then Parsers::GlbrcCnRootExcavationPlantParser # GLBRC plant root excavation soil pit samples
              when 45 then Parsers::GenericParser # lachat samples from the MLE sites.
              when 46 then Parsers::MLESoilParser # MLE CN soil samples
              when 47 then Parsers::MLESoilFractionParser # MLE CN soil fraction samples
              else false
              end

      klass&.new(date, sample_type_id)
    end
  end
end
