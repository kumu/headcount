RAILS_ENV ||= 'development'

desc "Takes a headcount"
task :headcount do
  sh "script/rails runner -e #{RAILS_ENV} \"Headcount.count!\""
end
