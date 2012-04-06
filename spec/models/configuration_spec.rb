require 'spec_helper'

describe Headcount::Configuration do
  let(:config) { Headcount.settings }
  
  before(:each) do
    Headcount.reset
  end
  
  describe '#timestamp' do
    it 'defaults to YYYY-MM-DD HH:MM:SS' do
      Headcount.settings.timestamp.should eq('%Y-%m-%d %H:%M:%S')
    end
  end
  
  describe '#path' do
    it 'defaults to db/headcount.json' do
      Headcount.settings.path.should eq('db/headcount.json')
    end
  end
  
  describe '#count' do
    context 'when given a single query' do
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
    
    context 'when given an explicit array' do
      it 'should register each query using the implied key' do
        config.count([User, Account])
        Headcount.find(:users).should eq(User)
        Headcount.find(:accounts).should eq(Account)
      end
    end
    
    context 'when given an implicit array' do
      it 'should register each query using the implied key' do
        config.count(User, Account)
        Headcount.find(:users).should eq(User)
        Headcount.find(:accounts).should eq(Account)
      end
    end
  end
end