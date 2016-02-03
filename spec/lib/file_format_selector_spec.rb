require './lib/file_format_selector.rb'

describe FileFormatSelector do
  it 'finds the right line parser prefix for lachat files' do
    file = File.open('test/data/OM_10-23-2014_10-03-22AM.csv')
    expect(FileFormatSelector.new.get_line_parser_prefix(file)).to eql('Parsers::Lachat')
  end
end
