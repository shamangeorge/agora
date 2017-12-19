require 'ox'
require 'awesome_print'
require 'json'
require "greek/i18n"
module GreekLit
  module Omiros
    PREFIX = "#{GreekLit.canonical_greek_lit_data}"
    AUTHOR = "homer"
    class Title
      attr_reader :name, :file, :author, :books
      def initialize title, file
        @name = title
        @file = file
      end
      def author
        @author ||= AUTHOR
      end
      def books
        xml = File.read(file)
        ox = Ox.parse(xml)
        @books ||= ox.nodes.last.nodes.last.nodes.first.nodes.first.nodes
      end
      def book_in_range? book_num
        book_num >= 1 || book_num <= books.size
      end
      def extract_from_xml book
        lines = []
        xml_lines = book.nodes.map do |node|
          if node.value == "l"
            node
          elsif node.value = "q"
            node.nodes.map do |l|
              l
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
        lines
      end
      def transform_to_obj book_num, lines
        mlines = []
        lines.each_with_index do |line, i|
          if line.value == "q"
            line.nodes.each do |n|
              if n.value == "l"
                mlines.push({
                  title: name,
                  book: book_num,
                  content: n.nodes.last,
                  number: n.attributes[:n]
                })
              end
            end
          elsif line.value == "l"
            mlines.push({
              title: name,
              book: book_num,
              content: line.nodes.last,
              number: line.attributes[:n]
            })
          end
        end
        mlines
      end
      def get_book i
        books[i]
      end
      def process_book book_num
        exit unless book_in_range? book_num
        book_index = book_num - 1
        book = get_book(book_index)
        lines = extract_from_xml(book)
        mlines = transform_to_obj(book_num, lines)
        mlines.each_with_index do |line, i|
          if line[:number].to_i != i + 1
            line[:index_problematic] = true
            #puts "^^^^ inspect me".red
            #exit
          end
          #puts "#{i + 1}:#{line.inspect}"
        end
      end
      def process_all
        (1..24).each do |i|
          process_book i
        end
      end
    end

    class Odisseia < Title
      def initialize
        @name = "odyssey"
        @file = "#{PREFIX}/tlg0012/tlg002/tlg0012.tlg002.perseus-grc2.xml"
      end
    end

    class Iliada < Title
      def initialize
        @name = "iliad"
        @file= "#{PREFIX}/tlg0012/tlg001/tlg0012.tlg001.perseus-grc2.xml"
      end
    end
  end
end
