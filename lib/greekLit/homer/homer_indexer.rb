module GreekLit
  module Omiros
    class Indexer

      def initialize title
        @title = title
        if @title == "iliad"
          @title_grc = "ιλιάδα"
        end
        if @title == "odyssey"
          @title_grc = "οδύσσεια"
        end
      end

      def author
        "homer"
      end

      def author_grc
        "όμηρος"
      end

      def title
        @title
      end

      def title_grc
        @title_grc
      end

      def _index
        "corpus-ancient-greek-#{author}-#{title}"
      end

      def now
        Time.now.utc.iso8601
      end

      def line_mapping book_num, linum, line, stripped
        {
          type: "line",
          timestamp: now,
          author: author,
          title: title,
          author_grc: author_grc,
          title_grc: title_grc,
          number: linum.to_i,
          book: book_num.to_i,
          content: line,
          content_stripped: Greek::I18n.atono(stripped)
        }
      end

      def word_mapping book_num, linum, idx, word
        {
          type: "word",
          timestamp: now,
          author: author,
          title: title,
          author_grc: author_grc,
          title_grc: title_grc,
          content: word,
          content_stripped: Greek::I18n.atono(word),
          number: idx,
          book: book_num.to_i,
          line: linum.to_i
        }
      end

      def book_mapping book_num, book_name
        {
          type: "book",
          timestamp: now,
          author: author,
          title: title,
          author_grc: author_grc,
          title_grc: title_grc,
          name: book_name,
          number: book_num.to_i
        }
      end

      def split_line book_num, line, linum, action
        # index the line
        _type = "line"
        stripped = line.gsub(/[[:punct:]]/, '')
        doc = line_mapping book_num, linum, line, stripped
        puts doc
        _id = "#{book_num}.#{linum}"
        # send to es
        #action.call _index, _type, _id, doc
        line.split(" ").each_with_index do |word, ii|
          word = word.gsub(/[[:punct:]]/, '')
          _id = "#{book_num}.#{linum}-#{ii}"
          _type = "word"
          doc = word_mapping book_num, linum, ii, word
          puts doc
          # send to es
          #action.call _index, _type, _id, doc
        end
      end

      def index_book book_num, action
        puts "Indexing author: #{author}, title: #{title}, book #{book_num}"
        book_lines = GreekLit::Omiros::Odisseia.new.process_book book_num
        # index the book data
        _type = "book"
        _id = book_num
        book_name = "book #{book_num}"
        doc = book_mapping book_num, book_name
        puts doc
        # send to es
        #action.call _index, _type, _id, doc
        book_lines.each_with_index do |line, i|
          linum = i + 1
          split_line book_num, line[:content], line[:number], action
        end
      end

      def index_books book_range, action
        book_range.each do |book_num|
          index_book book_num, action
        end
      end
    end
  end
end
