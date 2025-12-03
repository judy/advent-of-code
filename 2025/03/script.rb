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

  def solve
    io.each_line.sum do |line|
      battery_bank = line.strip.to_i
      get_max_joltage(battery_bank)
    end
  end

  # Out of the digits supplied in battery_bank, find the first instance of the
  # highest digit, that isn't the last digit. Then, find the highest digit after
  # that one, regardless of location. Return the concatenation of those two
  # digits as an integer.
  def get_max_joltage(battery_bank)
    battery_bank = battery_bank.to_s.chars
    first_max_index = battery_bank.index(battery_bank[0..-2].max) # skip last digit
    first_max = battery_bank[first_max_index]
    remaining_digits = battery_bank[(first_max_index + 1)..-1] # last digit included
    second_max = remaining_digits.max
    (first_max + second_max).to_i # concatenate and convert to integer
  end
end

class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 357
    assert_equal expected, solution
  end

  def test_get_max_joltage
    solution = Solution.new(nil)
    assert_equal 98, solution.get_max_joltage(987654321111111)
    assert_equal 89, solution.get_max_joltage(811111111111119)
    assert_equal 78, solution.get_max_joltage(234234234234278)
    assert_equal 92, solution.get_max_joltage(818181911112111)
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
