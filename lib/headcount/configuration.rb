module Headcount
  @@config = nil
  
  class << self
    def configure(&block)
      @@config ||= Configuration::Base.new
      @@config.evaluate(&block) if block_given?
      @@config
    end
    
    private
    def persistence_handler
      # eventually might want to support others
      Headcount::Persistence::File.new(@@config.path, :json)
    end
    
    def reset_configuration
      @@config = nil
    end
  end
  
  module Configuration
    class Base
      attr_accessor :path
      
      def initialize
        @path = 'db/headcount.json'
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