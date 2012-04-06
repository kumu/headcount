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

      def count(*arguments, &block)
        if list_given?(*arguments)
          count_each(arguments.flatten)
        else
          query   = arguments[0]
          options = arguments[1] || {}
          
          if query.respond_to?(:count)
            key = options[:as] || Headcount::Support.key_for(query)

            # just ignore blocks for now
            # not really finding a need for nested declarations
            #if block_given?
            #  evaluate(&block)
            #end

            Headcount.register(key, query)
          else
            raise UnsupportedQuery, 'query does not respond to :count'
          end
        end
      end
      
      private
      def list_given?(*arguments)
        arguments[0].is_a?(Array) || (arguments.length > 1 && !arguments[1].is_a?(Hash))
      end
      
      def count_each(queries)
        queries.each do |query|
          count(query)
        end
      end
    end
  end
end