require 'spec_helper'

# has to be defined as a contant or won't be available in configure block
PATH = 'spec/tmp/headcount.json'

describe Headcount do
  before(:each) do
    Headcount.configure do |config|
      config.path = PATH
      config.count User
    end
    
    File.delete(PATH) if File.exists?(PATH)
  end
  
  describe '.count!' do
    # right now a json file is the only supported form of persistence
    it 'writes the current headcount out to the persistence layer' do
      Headcount.count!
      File.exists?(PATH).should be_true
    end
    
    it 'appends to the existing contents' do
      3.times do
        Headcount.count!
      end
      
      File.open(PATH, 'r') do |file|
        file.readlines.should have(3).items
      end
    end
  end
end