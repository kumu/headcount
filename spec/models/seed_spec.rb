require 'spec_helper'

describe Headcount do
  describe '.seed' do
    it 'works' do
      Headcount.seed(DateTime.now - 3.days, 1.day).should have(4).items
    end
  end
end