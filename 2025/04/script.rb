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

  def solve_star_one
    find_and_mark_clearable_cells!
    grid.count { |cell| cell[:clearable] }
  end

  def solve_star_two
    find_and_mark_clearable_cells!
    grid.count { |cell| cell[:clearable] }
  end

  private

  def find_and_mark_clearable_cells!
    grid.each do |cell|
      # cell is clearable if it is '@' and has fewer than 4 neighboring '@'
      cell[:clearable] =
        cell[:char] == "@" &&
        grid.neighbors(cell[:x], cell[:y]).count { |n| n[:char] == '@' } < 4
    end
  end
end


class SolutionTest < Minitest::Test
  def test_solve_star_one
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_star_one
    expected = 13
    assert_equal expected, solution
  end

  def test_solve_star_two
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve_star_two
    expected = 43
    assert_equal expected, solution
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
