desc "Takes a headcount"
task :headcount do
  Headcount.count!
end
