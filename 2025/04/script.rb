#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  attr_reader :io, :grid
  def initialize(io)
    @io = io
    @grid = Grid.new(io)
  end

  def solve
    puts @grid
  end
end


class SolutionTest < Minitest::Test
  # def test_example
  #   io = File.open(__dir__ + '/sample.txt')
  #   solution = Solution.new(io).solve
  #   expected = 13
  #   assert_equal expected, solution
  # end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
