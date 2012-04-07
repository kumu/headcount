require 'headcount/support'
require 'headcount/registry'
require 'headcount/persistence'
require 'headcount/configuration'
require 'headcount/history'
require 'headcount/railtie' if defined?(Rails)

module Headcount
  @@registry = Headcount::Registry.new
  
  include Headcount::History
  
  class << self
    def register(key, query)
      key.to_sym.tap do |key|
        @@registry[key] = query
      end
    end
    
    def find(key)
      @@registry[key.to_sym]
    end
    
    # this method is getting a little messy -- need to clean it up
    # arg can either be a symbol or a time instance
    def count(arg = nil)
      if arg.is_a?(Symbol)
        key = arg
        count_for(key)
      else
        {}.tap do |headcount|
          now = DateTime.now
          time = arg || now
          headcount[:timestamp] = Headcount::Support.timestamp_for(time)
          
          @@registry.each do |key, query| # using map would return an array here
            query = query_for_time(query, time) unless time == now
            query = yield query if block_given? # can alter the query at execution
            
            headcount[key] = query.count
          end
        end
      end
    end

    def count!
      count.tap do |headcount|
        persist(headcount)
      end
    end
    
    def reset
      reset_registry
      reset_settings
    end
    
    private
    def reset_registry
      @@registry.clear
    end
    
    def count_for(key)
      if (query = find(key))
        query.count
      else
        raise Headcount::UnknownKey, "#{key} is not registered"
      end
    end
  end
end
