namespace :homer do
  desc "print out a whole book of the iliad"
  task :print_iliad_book, [:book_num] do |t, args|
    book_num = args[:book_num].to_i
    puts "Printing book #: #{book_num}"
    book = GreekLit::Omiros::Iliada.new.process_book book_num
    puts book
  end

  desc "print out a whole book of the odyssey"
  task :print_odyssey_book, [:book_num] do |t, args|
    book_num = args[:book_num].to_i
    puts "Printing book #: #{book_num}"
    GreekLit::Omiros::Odisseia.new.process_book book_num
  end

  desc "index homer on elasticsearch"
  task :index, [:title, :book_num] do |t, args|
    title = args[:title]
    book_num = args[:book_num].to_i
    puts "Indexing book #: #{book_num}"
    book = GreekLit::Omiros::Odisseia.new.process_book book_num
    puts "Started Indexing Homers #{title} book: #{book_num} at #{Time.now}"
    GreekLit::Omiros::Indexer.new(title)::index_book book_num, @es_create
    puts "End at #{Time.now}"
  end
end
