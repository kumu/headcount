require 'headcount/exceptions'

module Headcount
  module Support
    class << self
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
        if query < ActiveRecord::Base
          query.table_name
        elsif query.is_a?(ActiveRecord::Relation)
          query.table.name
        else
          raise ArgumentError, "Unable to imply key. Please provide one via :as."
        end
      end
    end
  end
end