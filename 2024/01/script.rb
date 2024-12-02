#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  attr_reader :io
  def initialize(io)
    @io = io
  end

  def solve_one
    # Convert file to nested array
    arrays = @io.each_line.map do |line|
      line.split.map(&:to_i)
    end

    # Transpose and sort each array
    array_1, array_2 = arrays.transpose.map(&:sort)

    # Iterate through each array and compare, adding up total distance
    distance = 0
    array_1.each_with_index do |num, index|
      distance += (num - array_2[index]).abs
    end

    distance
  end

  def solve_two
    # Convert file to nested array
    arrays = @io.each_line.map do |line|
      line.split.map(&:to_i)
    end

    # Transpose and sort each array
    array_1, array_2 = arrays.transpose.map(&:sort)

    # Iterate through each array and compare, adding up total distance
    distance = 0
    array_1.each_with_index do |num, index|
      multiplier = array_2.count(num)
      distance += num * multiplier
    end

    distance
  end
end

class SolutionTest < Minitest::Test
  def test_example_one
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_one
    expected = 11
    assert_equal expected, solution
  end

  def test_example_two
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_two
    expected = 31
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve_two
end
