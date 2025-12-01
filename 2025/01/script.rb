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
    solution = 0
    dial = 50

    # # To match the example output exactly:
    # puts "- The dial starts by pointing at #{dial}."

    @io.each_line do |line|
      direction, amount = line[0], line[1..].to_i
      raise "Unknown direction #{direction}" unless ['L', 'R'].include?(direction)

      amount *= -1 if direction == 'L'
      dial = (dial + amount) % 100

      # # To match the example output exactly:
      # puts "- The dial is rotated #{line.strip} to point at #{dial}."
      solution += 1 if dial == 0
    end

    solution
  end
end

class SolutionTest < Minitest::Test
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
