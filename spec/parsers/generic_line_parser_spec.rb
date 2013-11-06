#require 'spec_helper'
require './app/models/parsers/generic_line_parser.rb'


describe GenericLineParser do
  it 'parses a sample line' do
    date, plot, modifier, nh4, no3 = GenericLineParser.parse(' 10:34	113	20130708G1R1-10-a	     9104	   0.068					   288371	   2.954')
    date.should     == '20130708'
    plot.should     == 'G1R1'
    modifier.should == '10'
    nh4.should      == '0.068'
    no3.should      == '2.954'
  end
  it 'parses another sample line' do
    date, plot, modifier, nh4, no3 = GenericLineParser.parse('	10:44	122	20130708G3R1-10-a	    12545	   0.099					   128171	   1.325')	
    date.should     == '20130708'
    plot.should     == 'G3R1'
    modifier.should == '10'
    nh4.should      == '0.099'
    no3.should      == '1.325'
  end
  it 'does not parse a wrong line' do
    date, plot, modifier, nh4, no3 = GenericLineParser.parse('aa')
    date.should     == nil
    plot.should     == nil
    modifier.should == nil
    nh4.should      == nil
    no3.should      == nil
  end
end
