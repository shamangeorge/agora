#!/usr/bin/env ruby

require "greekLit"

titles = [GreekLit::Omiros::Iliada.new, GreekLit::Omiros::Odisseia.new]
titles.each do |title|
  title.process_all
end
