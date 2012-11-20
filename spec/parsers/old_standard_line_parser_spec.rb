require './app/models/parsers/old_standard_line_parser.rb'

describe OldStandardLineParser do
  describe 'a data line without flags' do
    before do
      @first, @second, @nh4, @no3 = OldStandardLineParser.parse('10:25	104	9-1a	       0.000000000	       0.000000000		   26576.603515625	       2.272032022	')
    end
    it 'parses the plot' do
      @first.should    == '9'
    end
    it' parses the rep' do
      @second.should   == '1'
    end
    it 'parses the nh4' do
      @nh4.should      == '0.000000000'
    end
    it 'parses the no3' do
      @no3.should      == '2.272032022'
    end
  end

  describe 'a data line with flags' do
    before do
      @first, @second, @nh4, @no3 = OldStandardLineParser.parse('10:25	104	9-3b	       0.000000000	       0.000000000	lo	   26576.603515625	       2.272032022	a-')
    end
    it 'parses the plot' do
      @first.should    == '9'
    end
    it' parses the rep' do
      @second.should   == '3'
    end
    it 'parses the nh4' do
      @nh4.should      == '0.000000000'
    end
    it 'parses the no3' do
      @no3.should      == '2.272032022'
    end
  end

  describe 'a scaleup data line' do
    before do
      @first, @second, @nh4, @no3 = OldStandardLineParser.parse('10:24	111	L01S3B	   10924.598632812	       0.125434265		    7629.784179688	       0.082236394	')
    end
    it 'parses the plot' do
      @first.should    == 'L01'
    end
    it' parses the rep' do
      @second.should   == '3'
    end
    it 'parses the nh4' do
      @nh4.should      == '0.125434265'
    end
    it 'parses the no3' do
      @no3.should      == '0.082236394'
    end
  end

  describe 'another scaleup data line' do
    before do
      @first, @second, @nh4, @no3 = OldStandardLineParser.parse(' 11:52	161	L02S10A	   11500.867187500	       0.131874472		    8088.541503906	       0.087122686	')
    end
    it 'parses the plot' do
      @first.should    == 'L02'
    end
    it' parses the rep' do
      @second.should   == '10'
    end
    it 'parses the nh4' do
      @nh4.should      == '0.131874472'
    end
    it 'parses the no3' do
      @no3.should      == '0.087122686'
    end
  end

  describe 'another scaleup data line' do
    before do
      @first, @second, @nh4, @no3 = OldStandardLineParser.parse( '12:37	190	L03S9C	    9805.619140625	       0.112928890		    3098.538818359	       0.033973396	')
    end
    it 'parses the plot' do
      @first.should    == 'L03'
    end
    it' parses the rep' do
      @second.should   == '9'
    end
    it 'parses the nh4' do
      @nh4.should      == '0.112928890'
    end
    it 'parses the no3' do
      @no3.should      == '0.033973396'
    end
  end
end
