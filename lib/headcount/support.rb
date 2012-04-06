require 'headcount/exceptions'

module Headcount
  module Support
    class << self
      def timestamp_for(time)
        time.strftime(Headcount.settings.timestamp)
      end
      
      def key_for(query, path = [])
        key = lookup_key(query)
        
        # if path.empty?
        #           key.pluralize
        #         else
        #           path.reverse.map {|key| key.singularize}
        key
      end
      
      private
      def lookup_key(query)
        key = nil
        
        if query
          if query < ActiveRecord::Base
            key = query.table_name
          elsif query.is_a?(ActiveRecord::Relation)
            key = query.table.name
          end
        end
        
        if key
          key.to_sym
        else
          raise Headcount::UnsupportedQuery, "Unable to imply key. Please provide one via :as."
        end
      end
    end
  end
end