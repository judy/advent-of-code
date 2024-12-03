#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  MUL_REGEX = /mul\((?<a>\d{1,3}),(?<b>\d{1,3})\)/
  attr_reader :io
  def initialize(io)
    @io = io
  end

  def solve_simple
    code = io.readlines.map(&:strip).join

    total = 0
    code.scan(MUL_REGEX) do |a, b|
      a = a.to_i
      b = b.to_i
      total += a * b
    end

    total
  end

  def solve
    code = io.readlines.map(&:strip).join

    # delete blocks of don't to do. .*? means lazy. also delete block at end if don't doesn't reach a do
    code.gsub!(/don\'t\(\).*?do\(\)|don\'t\(\).*?$/, '')

    total = 0
    code.scan(MUL_REGEX) do |a, b|
      a = a.to_i
      b = b.to_i
      total += a * b
    end

    total
  end
end

class SolutionTest < Minitest::Test
  def test_simple_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_simple
    expected = 161
    assert_equal expected, solution
  end

  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 48
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
