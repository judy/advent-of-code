#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'
require_relative '../../shared/grid.rb'
require 'tty-cursor'

CURSOR = TTY::Cursor
TTYOUTPUT = File.open('/dev/ttys003', 'w+')
TTYOUTPUT.print CURSOR.clear_screen

class Solution
  attr_reader :io, :grid, :solution

  def initialize(io)
    @io = io
    @grid = Grid.new(io)
    @solution = 0
  end

  def solve_star_one
    find_and_mark_clearable_cells!
    grid.count { |cell| cell[:clearable] }
  end

  def solve_star_two
    @solution = 0
    sleep(0.75) # gimme a second to see the TTY output
    draw

    while true
      find_and_mark_clearable_cells!
      current_count = grid.count { |cell| cell[:clearable] }
      break if current_count.zero?
      @solution += current_count
      draw
      clear_the_clearable_cells!
      draw
    end

    @solution
  end

  private

  def draw
    sleep(0.05)
    # TTYOUTPUT.print CURSOR.clear_screen_up
    TTYOUTPUT.print CURSOR.move_to(0, 0)
    TTYOUTPUT.puts grid.draw
    TTYOUTPUT.puts
    TTYOUTPUT.puts "Cleared so far: #{@solution}"
  end

  def find_and_mark_clearable_cells!
    grid.each do |cell|
      # cell is clearable if it is '@' and has fewer than 4 neighboring '@'
      cell[:clearable] =
        cell[:char] == "@" &&
        grid.neighbors(cell[:x], cell[:y]).count { |n| n[:char] == '@' } < 4
    end
  end

  def clear_the_clearable_cells!
    grid.each do |cell|
      if cell[:clearable]
        cell[:char] = '.'
        cell.delete(:clearable)
      end
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
  puts Solution.new(ARGF).solve_star_two
end
