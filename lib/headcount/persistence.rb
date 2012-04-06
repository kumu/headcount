require 'headcount/persistence/file'

module Headcount
  class << self
    private
    def persist(headcount)
      persistence_handler.save(count)
    end
  end
end