module Headcount
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/headcount_tasks.rake"
    end
  end
end