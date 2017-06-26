#!/usr/bin/env ruby

require 'ox'
require 'awesome_print'

title = "iliad"
author = "homer"
file = "canonical-greekLit/data/tlg0012/tlg001/tlg0012.tlg001.perseus-grc2.xml"
xml = File.read(file)
ox = Ox.parse(xml)

books = ox.nodes.last.nodes.last.nodes.first.nodes.first.nodes

#books.each_with_index do |book, book_index|
book_num = ARGV[0].to_i # 1-24
if book_num < 1 || book_num > books.size
  puts "There are only #{books.size} in #{author}:#{title}"
end
book_index = book_num - 1
#book_num = book_index + 1
book = books[book_index]
lines = []
xml_lines = book.nodes.map do |node|
  if node.value == "l"
    node
  elsif node.value = "q"
    node.nodes.map do |l|
      l unless l.value != "l"
    end
  end
end.each do |line|
  if line.class == Array
    line.each do |k|
      lines.push(k) unless k.nil?
    end
  else
    lines.push(line) unless line.nil?
  end
end
jsons = lines.map do |line|
  number = line.attributes[:n].to_i
  content = line.nodes.first
  if line.nodes.first.class == Ox::Element
    content = line.nodes.last
  end
  {
    book: book_num,
    number: number,
    content: content
  }
end
num_lines = jsons.last[:number] - jsons.first[:number]
if jsons.size - 1 == num_lines
  puts "#"*90
  puts jsons.last.inspect.green
else
  puts "#"*90
  puts "book: #{book_num}".red
  puts "jsons: #{jsons.size}".red
  puts "num_lines: #{num_lines}".red
  jsons.each_with_index do |obj, i|
    if i + 1 != obj[:number]
      puts (i + 1).to_s.yellow
      puts obj[:number].to_s.yellow
      puts obj.inspect
    end
  end
end
#end
