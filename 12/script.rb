#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

# Solution goes here

class Test < MiniTest::Test
  def test_small_example
    skip
    io = StringIO.new <<~STRING
      Sab
      gEc
      fed
    STRING
    expected = 8
  end
  def test_given_example
    skip
    io = StringIO.new <<~STRING
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    STRING
    expected = 31
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
