#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'
require_relative '../../shared/grid.rb'

class Solution
  attr_reader :io, :grid
  def initialize(io)
    @io = io
    @grid = Grid.new(io)
  end

  def solve
    grid.each do |cell|
      # cell is clearable if it is '@' and has fewer than 4 neighboring '@'
      cell[:clearable] =
        cell[:char] == "@" &&
        grid.neighbors(cell[:x], cell[:y]).count { |n| n[:char] == '@' } < 4
    end

    grid.count { |cell| cell[:clearable] }
  end
end


class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 13
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
