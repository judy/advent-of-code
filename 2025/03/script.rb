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

  def solve(digits = 2)
    io.each_line.sum do |line|
      battery_bank = line.strip.to_i
      get_max_joltage(battery_bank, digits).to_i
    end
  end

  def get_max_joltage(battery_bank, digits = 2)
    battery_bank = battery_bank.to_s.chars
    first_max_index = battery_bank.index(battery_bank[0..-(digits)].max)
    first_max = battery_bank[first_max_index]

    return first_max if digits == 1

    digits -= 1
    remaining_digits = battery_bank[(first_max_index + 1)..-1].join # convert back to string
    remaining_digits = get_max_joltage(remaining_digits, digits)

    first_max + remaining_digits
  end
end

class SolutionTest < Minitest::Test
  def test_example_gold_star_1
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 357
    assert_equal expected, solution
  end

  def test_example_gold_star_2
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve(12)
    expected = 3121910778619
    assert_equal expected, solution
  end

  def test_get_max_joltage
    solution = Solution.new(nil)
    assert_equal "98", solution.get_max_joltage(987654321111111)
    assert_equal "89", solution.get_max_joltage(811111111111119)
    assert_equal "78", solution.get_max_joltage(234234234234278)
    assert_equal "92", solution.get_max_joltage(818181911112111)
  end

  def test_get_max_joltage_single_digit
    solution = Solution.new(nil)
    assert_equal "9", solution.get_max_joltage(987654321111111, 1)
    assert_equal "9", solution.get_max_joltage(811111111111119, 1)
    assert_equal "8", solution.get_max_joltage(811111111111117, 1)
  end

  def test_get_max_joltage_three_digits
    solution = Solution.new(nil)
    assert_equal "987", solution.get_max_joltage(987654321111111, 3)
    assert_equal "819", solution.get_max_joltage(811111111111119, 3)
    assert_equal "817", solution.get_max_joltage(811111111111117, 3)
  end

  def test_get_max_joltage_twelve_digits
    solution = Solution.new(nil)
    assert_equal "987654321111", solution.get_max_joltage(987654321111111, 12)
    assert_equal "811111111119", solution.get_max_joltage(811111111111119, 12)
    assert_equal "434234234278", solution.get_max_joltage(234234234234278, 12)
    assert_equal "888911112111", solution.get_max_joltage(818181911112111, 12)
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve(12)
end
