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

    @io.each_line do |line|
      direction, amount = line[0], line[1..].to_i
      raise "Unknown direction #{direction}" unless ['L', 'R'].include?(direction)
      raise "Amount must be positive" if amount <= 0

      # Move dial one at a time to count zeros, even when moving past them.
      amount.times do
        dial += direction == 'R' ? 1 : -1
        dial = 0 if dial == 100
        dial = 99 if dial == -1
        raise "Dial out of bounds: #{dial}" unless dial.between?(0, 99) # sanity check

        solution += 1 if dial == 0 # count every time we hit zero, even moving past it
      end
    end

    solution
  end
end

class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 6
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
