#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

# Solution goes here

class Test < MiniTest::Test
  def test_example
    skip
    io = StringIO.new <<~STRING
      # example input goes here
    STRING
    expected = "example output goes here"
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
