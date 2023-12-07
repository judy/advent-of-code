#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  def initialize
    @io = io
  end
end

class SolutionTest < MiniTest::Test
  def test_example
    skip
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = "expected"
    assert_equal expected, solution
  end
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
