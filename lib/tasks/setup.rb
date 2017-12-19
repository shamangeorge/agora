namespace :setup do
  desc "A test task to check whether a directory exists"
  task :check do
    puts "Enter the name of the destination directory: "
    @dir = STDIN.gets.strip  #Calling gets by itself would result in a call to "Kernel#gets" which is not what we want.

    if  File.directory?("../#{@dir}") #Checks whether the user requested directory exists and if not creates a new one.
      puts "The directory exists"
      setup_copy #Calls setup_copy method
    else
      puts "Creating the requested directory..."
      mkdir "../#{@dir}"
      setup_copy
    end
  end

  desc "A test task to copy things around"
  task :copy => :check do #A task dependency
    puts "Copying files..."
    cp_r '.', "../#{@dir}"
    puts "Done.! :)"
  end
end
