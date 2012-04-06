require 'spec_helper'

describe Headcount::Support do
  describe '.timestamp_for' do
    let(:now) { DateTime.now }
    
    it 'returns a timestamp formatted according to the configured timestamp format' do
      Headcount.settings.timestamp = '%Y'
      Headcount::Support.timestamp_for(now).should eq(now.year.to_s)
    end
  end
  
  describe '.key_for' do
    context 'when given a valid query' do
      it 'returns a symbol' do
        Headcount::Support.key_for(User).should be_a(Symbol)
      end

      it 'returns a key based on the underlying table name of the given query' do
        Headcount::Support.key_for(User).should eq(:users)
      end
      
      context 'when given a path' do
        # need to test concatention
        # only the last key should be pluralized
        # :active, [:users] => :active_users
      end
    end
    
    context 'when given an invalid query' do
      it 'raises a Headcount::UnsupportedQuery error' do
        lambda { Headcount::Support.key_for(nil) }.should raise_error(Headcount::UnsupportedQuery)
      end
    end
  end
end