require 'spec_helper'

describe Headcount do
  before(:each) do
    Headcount.reset
  end
  
  describe '.find' do
    context 'when the key is unknown' do
      it 'should simply return nil' do
        Headcount.find(:missing).should be_nil
      end
    end
  end
  
  describe '.reset' do
    it 'should remove all registered keys' do
      Headcount.register(:users, User)
      Headcount.reset
      Headcount.find(:users).should be_nil
    end
  end
  
  describe '.register' do
    let(:query) { User.where(true) }
    
    it 'should register the query for the given key' do
      Headcount.register(:users, query)
      Headcount.find(:users).should eq(query)
    end
    
    it 'should return the registered key' do
      Headcount.register(:users, query).should eq(:users)
    end
    
    it 'should always return the key as a symbol' do
      Headcount.register("users", query).should eq(:users)
    end
  end
  
  describe '.registry' do
    it 'should not be publicly accessible' do
      lambda { Headcount.registry }.should raise_error(NoMethodError)
    end
  end
  
  describe '.count' do    
    context 'when called without arguments' do
      let(:headcount) do 
        Headcount.register(:users, User)
        Headcount.count
      end
      
      describe 'result' do
        it 'is a hash' do
          headcount.should be_a(Hash)
        end
        
        it 'includes a timestamp' do
          headcount.should have_key(:timestamp)
        end

        describe '[:timestamp]' do
          it 'should be formatted according to configured timestamp format' do
            timestamp = headcount[:timestamp]
            time = DateTime.parse(timestamp)

            timestamp.should eq(Headcount::Support.timestamp_for(time))
          end
        end
        
        it 'includes the current count for each key in the registry' do
          headcount.should have_key(:users)
          headcount[:users].should eq(User.count)
        end
      end
    end
    
    context 'when given a key' do
      context 'and the key is registered' do
        it 'returns the count for the registered key' do
          Headcount.register(:users, User)
          Headcount.count(:users).should eq(User.count)
        end
      end
      
      context 'and the key is unknown' do
        it 'raises a Headcount::UnknownKey error' do
          lambda { Headcount.count(:missing) }.should raise_error(Headcount::UnknownKey)
        end
      end
      
    end
  end
end