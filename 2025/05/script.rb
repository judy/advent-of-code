#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  attr_reader :ranges, :ingredients
  def initialize(io)
    @ranges = []
    @ingredients = []

    # get ranges
    while true
      line = io.gets&.chomp
      break if line == ""
      @ranges << line.split('-').map(&:to_i)
    end

    # get ingredients
    while true
      line = io.gets&.chomp
      break if line.nil?
      @ingredients << line.to_i
    end
  end

  def solve
    0
  end
end

class SolutionTest < Minitest::Test
  def test_solution_initialization
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io)
    assert_equal [[3, 5], [10, 14], [16, 20], [12, 18]], solution.ranges
    assert_equal [1, 5, 8, 11, 17, 32], solution.ingredients
  end

  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 3
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
