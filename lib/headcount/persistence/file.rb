module Headcount
  module Persistence
    class File
      def initialize(path, format)
        @path = path
        @format = format
      end
      
      def save(headcount)
        ::File.open(@path, 'a') do |file|
          file.puts headcount.to_json
        end
      end
    end
  end
end