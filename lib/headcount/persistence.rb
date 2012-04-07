require 'headcount/persistence/file'

module Headcount
  class << self
    private
    def persist(headcounts, options = {})
      headcounts = Array.wrap(headcounts)
      persistence_handler.save(headcounts, options)
    end
  end
end