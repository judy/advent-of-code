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
    io.split("\n").map do |line|
      line = line.chomp
      first_num = line.scan(/\d+/).first.to_i
      second_num = line.reverse.scan(/\d+/).first.to_i
      (first_num * 10) + second_num
    end.sum
  end
end

class SolutionTest < MiniTest::Test
  def test_line
    # io = File.open(__dir__ + '/sample.txt')
    input = <<~EOS
      1abc2
    EOS
    solution = Solution.new(input).solve
    expected = 12 # TODO: put example here!
    assert_equal expected, solution
  end
  def test_example
    # io = File.open(__dir__ + '/sample.txt')
    input = <<~EOS
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    EOS
    solution = Solution.new(input).solve
    expected = 142 # TODO: put example here!
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts Solution.new(ARGF).solve
end
