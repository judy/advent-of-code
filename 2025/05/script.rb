#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  attr_reader :ranges, :ingredients
  def initialize(io)
    @ranges, @ingredients = io.partition { |line| line.include?("-") }
    @ranges.collect! do |range|
      min, max = range.split("-").collect(&:to_i)
      (min..max)
    end
    @ingredients = @ingredients.map(&:chomp).reject(&:empty?).map(&:to_i)
  end

  def solve_star_one
    ingredients.count do |ingredient|
      ranges.any? { |range| range.include?(ingredient ) }
    end
  end

  def solve_star_two

  end
end

class SolutionTest < Minitest::Test
  def test_solution_initialization
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io)
    assert_equal [3..5, 10..14, 16..20, 12..18], solution.ranges
    assert_equal [1, 5, 8, 11, 17, 32], solution.ingredients
  end

  def test_solve_star_one
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_star_one
    expected = 3
    assert_equal expected, solution
  end

  def test_solve_star_two
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_star_two
    expected = 14
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve_star_two
end
