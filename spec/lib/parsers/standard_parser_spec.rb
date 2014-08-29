require 'rails_helper'

describe Parsers::StandardParser do
  describe 'a line of lter data' do
    before do
      @parser = Parsers::Parser.for(2,Date.today)
      @parser.process_line('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				', Parsers::StandardLineParser)
    end

    it 'parses' do
      expect(@parser.sample).to_not be_nil
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('T2R1')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.048
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.714
    end
  end

  describe 'a line of lter T21 data' do
    before do
      @parser = Parsers::Parser.for(16,Date.today)
      @parser.process_line('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				', Parsers::StandardLineParser)
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('T2R1')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.048
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.714
    end
  end

  describe 'a line of glbrc data' do
    before do
      @parser = Parsers::Parser.for(8,Date.today)
      @parser.process_line('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				', Parsers::StandardLineParser)
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('G2R1')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.048
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.714
    end
  end

  describe 'a line of old glbrc data' do
    before do
      @parser = Parsers::Parser.for(3,Date.today)
      @parser.process_line(' 12:37	190	L03S9C	    9805.619140625	       0.112928890		    3098.538818359	       0.033973396	', Parsers::OldStandardLineParser)
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('L03S9')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.112928890 
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.033973396
    end

  end

  describe 'another line of glbrc data' do
    before do 
      @parser = Parsers::Parser.for(8,Date.today)
      @parser.process_line('14:38	264	3-1a	     236629	   11.523					    157358	   10.109				', Parsers::StandardLineParser)
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('G3R1')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 11.523
      assert_includes @parser.measurements.collect {|x| x.amount}, 10.109
    end
  end


  describe 'a line of junk' do
    before do
      @parser = Parsers::Parser.for(2,Date.today)
      @parser.process_line('10:38	bad-1a	     6282	   0.048					    74108	   0.714				', Parsers::StandardLineParser)
    end

    it "should return no sample" do
      expect(@parser.sample).to be_nil
    end
  end

end
