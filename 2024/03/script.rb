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
    code = io.readlines.map(&:strip).join
    re = /mul\((?<a>\d{1,3}),(?<b>\d{1,3})\)/

    total = 0
    code.scan(re) do |a, b|
      a = a.to_i
      b = b.to_i
      total += a * b
    end

    total
  end
end

class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 161 # TODO: put example here!
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
