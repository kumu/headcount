module Headcount
  class Registry < Hash
  end
  
  class << self
    def reset_registry
      @@registry.clear
    end
  end
end