#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  NUMBER_TO_INT = {
    '0' => 0,
    '1' => 1,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9
  }

  attr_reader :io
  def initialize(io)
    @io = io
  end

  def solve
    io.readlines.map do |line|
      line = line.chomp
      digits = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten
      first_num = NUMBER_TO_INT[digits.first]
      second_num = NUMBER_TO_INT[digits.last]
      # puts "#{digits.first}: #{first_num}, #{digits.last}: #{second_num}, = #{(first_num * 10) + second_num}"
      (first_num * 10) + second_num
    end.sum
  end
end

class SolutionTest < MiniTest::Test
  def test_line
    # io = File.open(__dir__ + '/sample.txt')
    input = StringIO.new <<~EOS
      1abc2
    EOS
    solution = Solution.new(input).solve
    expected = 12 # TODO: put example here!
    assert_equal expected, solution
  end
  def test_example
    # io = File.open(__dir__ + '/sample.txt')
    input = StringIO.new <<~EOS
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    EOS
    solution = Solution.new(input).solve
    expected = 142 # TODO: put example here!
    assert_equal expected, solution
  end

  def test_line_two
    # io = File.open(__dir__ + '/sample.txt')
    input = StringIO.new <<~EOS
      1abconeight
    EOS
    solution = Solution.new(input).solve
    expected = 18 # TODO: put example here!
    assert_equal expected, solution
  end

  def test_example_two
    # io = File.open(__dir__ + '/sample.txt')
    input = StringIO.new <<~EOS
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    EOS
    solution = Solution.new(input).solve
    expected = 281 # TODO: put example here!
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  io = File.open(__dir__ + '/data.txt')
  puts Solution.new(io).solve
end
