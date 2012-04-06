require 'headcount/support'
require 'headcount/registry'
require 'headcount/persistence'
require 'headcount/configuration'
require 'headcount/railtie' if defined?(Rails)

module Headcount
  @@registry = Headcount::Registry.new

  class << self
    def register(key, query)
      key.to_sym.tap do |key|
        @@registry[key] = query
      end
    end
    
    def find(key)
      @@registry[key.to_sym]
    end

    def count(key = nil)
      if key
        count_for(key)
      else
        {}.tap do |headcount|
          headcount[:timestamp] = Headcount::Support.timestamp_for(DateTime.now)
          
          @@registry.each do |key, query| # using map would return an array here
            headcount[key] = query.count
          end
        end
      end
    end

    def count!
      persist(count)
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
