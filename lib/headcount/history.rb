module Headcount
  module History
    extend ActiveSupport::Concern
    
    module ClassMethods
      def seed(start, interval)
        time = start
        now = DateTime.now
        headcounts = []
        
        while time < now
          headcounts << Headcount.count(time)
          time += interval
        end
        
        headcounts
      end
      
      def seed!(start, interval)
        seed(start, interval).tap do |headcounts|
          persist(headcounts, {:reset => true})
        end
      end
      
      private
      def query_for_time(query, time)
        begin
          query.where('created_at <= ?', time).tap do |modified_query|
            modified_query.count # will trigger an error immediately so we can handle it below
          end
        rescue
          query # just return the original query
        end
      end
    end
  end
end