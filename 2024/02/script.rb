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
    safe_reports = 0
    io.each_line do |line|
      numbers = line.split.map(&:to_i)

      # sanity check: if there's a single number in the line, it's safe(?)
      if numbers.count == 1
        safe_reports += 1
        next
      end

      direction = numbers[0] < numbers[1] ? :increasing : :decreasing
      report = :safe

      # Ensure that the numbers are only increasing or decreasing, by checking the difference between each number
      numbers = numbers.to_enum
      begin
        while true
          a = numbers.next
          b = numbers.peek
          difference = a - b
          if direction == :decreasing && difference >= 1 && difference <= 3
            next
          elsif direction == :increasing && difference <= -1 && difference >= -3
            next
          else
            report = :unsafe
            break
          end
        end
      rescue StopIteration
        # We made it to the end of the numbers, so it's safe
        safe_reports += 1 if report == :safe
      end

    end

    safe_reports
  end
end

class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 2
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
