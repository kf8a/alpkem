require 'rails_helper'

describe Parsers::GenericLineParser do
  it 'parses a sample line' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse(' 10:34	113	20130708G1R1-10-a	     9104	   0.068					   288371	   2.954')
    expect(date).to eql('20130708')
    expect(plot).to eql('G1R1')
    expect(modifier).to eql('10')
    expect(nh4).to eql('0.068')
    expect(no3).to eql('2.954')
  end
  it 'parses another sample line' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse('	10:44	122	20130708G3R1-10-a	    12545	   0.099					   128171	   1.325')
    expect(date).to eql('20130708')
    expect(plot).to eql('G3R1')
    expect(modifier).to eql('10')
    expect(nh4).to eql('0.099')
    expect(no3).to eql('1.325')
  end

  it 'parses a line with a space after the a' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse('	10:44	122	20130708G10R1-25-a 	    12545	   0.099					   128171	   1.325')
    expect(date).to eql('20130708')
    expect(plot).to eql('G10R1')
    expect(modifier).to eql('25')
    expect(nh4).to eql('0.099')
    expect(no3).to eql('1.325')
  end

  it 'parses a scalup plot' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse('	10:44	122	20130708M1S01-25-a 	    12545	   0.099					   128171	   1.325')
    expect(date).to eql('20130708')
    expect(plot).to eql('M1S01')
    expect(modifier).to eql('25')
    expect(nh4).to eql('0.099')
    expect(no3).to eql('1.325')
  end

  it 'parses a micro plot' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse('	10:44	122	20171115G8R1micro-25-a 	    12545	   0.099					   128171	   1.325')
    expect(date).to eql('20171115')
    expect(plot).to eql('G8R1micro')
    expect(modifier).to eql('25')
    expect(nh4).to eql('0.099')
    expect(no3).to eql('1.325')
  end

  it 'parse a plot without a modifier' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse('	10:44	122	20130708G4R1-a 	    12545	   0.099					   128171	   1.325')
    expect(date).to eql('20130708')
    expect(plot).to eql('G4R1')
    expect(modifier).to be_nil
    expect(nh4).to eql('0.099')
    expect(no3).to eql('1.325')
  end

  it 'does not parse a wrong line' do
    date, plot, modifier, nh4, no3 = Parsers::GenericLineParser.parse('aa')
    expect(date).to be_nil
    expect(plot).to be_nil
    expect(modifier).to be_nil
    expect(nh4).to be_nil
    expect(no3).to be_nil
  end
end
