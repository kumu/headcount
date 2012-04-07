module Headcount
  module Persistence
    class File
      def initialize(path, format)
        @path = path
        @format = format
      end
      
      def save(headcounts, options = {})
        ::File.delete(@path) if ::File.exists?(@path) if options[:reset]
          
        ::File.open(@path, 'a') do |file|
          headcounts.each do |headcount|
            file.puts headcount.to_json
          end
        end
      end
    end
  end
end