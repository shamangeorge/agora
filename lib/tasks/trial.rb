namespace :trial do
  desc "first task"
  task :first_task do
    puts "First task"
  end

  desc "second task"
  task :second_task do
    puts ">>Second task"
  end

  desc "third task"
  task :third_task => [:first_task, :second_task] do
    puts ">>>>Hurray. This is the third task"
    puts " This task depends on the first_task and second_task and won’t be executed unless both the dependencies are satisfied."
    print "The syntax for declaring dependency is "
    puts " :main_task => :dependency"
    puts "and if there are more than 1 dependency, place all the dependencies inside the [] separated by commas "
    puts ":main_task => [:dep1, :dep2]"
  end

  desc "tests"
  task :tests, [:arg1, :arg2] do |t, args|
    puts "First argument: #{ args[:arg1] }"
    puts "Second argument: #{args[:arg2]}"
  end
end
