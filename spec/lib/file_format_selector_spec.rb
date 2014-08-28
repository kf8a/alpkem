require './lib/file_format_selector.rb'

describe FileFormatSelector do
  it 'finds the right file line parser prefix for NO3 alpkem files' do
      file = File.open('spec/fixtures/3262012B.TXT')
      expect(FileFormatSelector.new.get_line_parser_prefix(file)).to eql('NO3')
  end
  it 'finds the right file line parser prefix for NO3 alpkem files' do
      file = File.open('test/data/3262012B-nh4.TXT')
      expect(FileFormatSelector.new.get_line_parser_prefix(file)).to eql('NH4')
  end
  it 'finds the right line parser prefix for dual elment alpkem files' do
    file = File.open('test/data/100419L.TXT')
    expect(FileFormatSelector.new.get_line_parser_prefix(file)).to eql('')
  end
  it 'finds the right line parser prefix for old alpkem files' do
    file = File.open('test/data/072709SN.TXT')
    expect(FileFormatSelector.new.get_line_parser_prefix(file)).to eql('Old')
  end
end
