module Headcount
  @@config = nil
  
  class << self
    def settings
      @@config ||= Configuration::Base.new
    end
    
    def configure(&block)
      settings.evaluate(&block)
    end
    
    private
    def persistence_handler
      # eventually might want to support others
      Headcount::Persistence::File.new(@@config.path, :json)
    end
    
    def reset_settings
      @@config = nil
    end
  end
  
  module Configuration
    class Base
      attr_accessor :path, :timestamp
      
      def initialize
        @path       = 'db/headcount.json'
        @timestamp  = '%Y-%m-%d %H:%M:%S'
      end
      
      def evaluate(&block)
        instance_exec(self, &block)
      end

      def count(query, options = {}, &block)
        raise UnsupportedQuery, 'query does not respond to :count' unless query.respond_to?(:count)

        key = options[:as] || Headcount::Support.key_for(query)

        # just ignore blocks for now
        #if block_given?
        #  evaluate(&block)
        #end

        Headcount.register(key, query)
      end
    end
  end
end