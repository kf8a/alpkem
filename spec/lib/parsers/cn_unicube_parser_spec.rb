# frozen_string_literal: true

require "rails_helper"

describe Parsers::CNUnicubeParser do
  describe 'a line of data' do
    before do
      @parser = Parsers::Parser.for(51, Date.today)
      @parser.process_line('4.78,20201019-T01R2-ZEAMX.GR,Plant,2752,59724,0.9989,1.0996,1.2967,43.3262,33.4116,,0,0,0,0,,2025-02-26,14:56:45')
    end
    it 'should have the right date' do
      expect(@parser.sample.sample_date).to eq(Date.civil(2020,10,19))
    end

    it 'should have the right plot' do
      expect(@parser.sample.plot.name).to eq('T1R2-ZEAMX.GR')
    end

    it 'should have the right carbon measurement' do
      expect(@parser.sample.measurements.collect {|x| x.amount}).to include(1.2967)
    end

    it 'should have the right nitrogen measurement' do
      expect(@parser.sample.measurements.collect {|x| x.amount}).to include(43.3262)
    end
  end

end