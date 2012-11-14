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
end
