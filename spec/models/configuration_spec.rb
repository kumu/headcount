require 'spec_helper'

describe Headcount::Configuration do
  let(:config) { Headcount.configure }
  
  describe '#count' do
    it 'should return the registration key' do
      config.count(User).should eq(:users)
    end
    
    it 'should add the given query to the registry' do
      Headcount.find(config.count(User)).should eq(User)
    end
    
    context 'when key is given' do
      it 'should override the default key' do
        config.count(User, :as => :members)
        Headcount.find(:members).should eq(User)
      end
    end
    
    context 'when a bad query is given' do
      it 'throws a Headcount::UnsupportedQuery error' do
        lambda { config.count(Object) }.should raise_error(Headcount::UnsupportedQuery)
      end
    end
  end
end