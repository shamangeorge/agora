namespace :main do
  desc "test"
  task :test do
    if true
      puts "Calling test2 task."
      Rake::Task["main:test2"].invoke #invokes main:test2
    else
      abort()
    end
  end

  desc "test2"
  task :test2 do
      puts ">Test2 task invoked"
  end
end
