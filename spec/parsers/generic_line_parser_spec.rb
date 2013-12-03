require File.dirname(__FILE__) + '/../../app/parsers/generic_line_parser.rb'
require File.dirname(__FILE__) + '/../../lib/parser_matcher.rb'


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

  it 'parses a line with a space after the a' do
    date, plot, modifier, nh4, no3 = GenericLineParser.parse('	10:44	122	20130708G10R1-25-a 	    12545	   0.099					   128171	   1.325')	
    date.should     == '20130708'
    plot.should     == 'G10R1'
    modifier.should == '25'
    nh4.should      == '0.099'
    no3.should      == '1.325'
  end

  it 'parses a scalup plot' do
    date, plot, modifier, nh4, no3 = GenericLineParser.parse('	10:44	122	20130708M1S01-25-a 	    12545	   0.099					   128171	   1.325')	
    date.should     == '20130708'
    plot.should     == 'M1S01'
    modifier.should == '25'
    nh4.should      == '0.099'
    no3.should      == '1.325'
  end

  it 'parse a plot without a modifier' do
    date, plot, modifier, nh4, no3 = GenericLineParser.parse('	10:44	122	20130708G4R1-a 	    12545	   0.099					   128171	   1.325')	
    date.should     == '20130708'
    plot.should     == 'G4R1'
    modifier.should == nil
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
