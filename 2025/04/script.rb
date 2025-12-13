#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Grid
  include Enumerable

  def initialize(io)
    @grid = io.each_line.map.with_index do |line, y|
      line.chomp.chars.map.with_index do |char, x|
        { char:, x:, y: }
      end
    end
  end

  def to_s
    @grid.map do |row|
      row.map { |cell| cell[:char] }.join
    end.join("\n")
  end

  def each
    @grid.each do |row|
      row.each do |cell|
        yield cell
      end
    end
  end

  def get(x, y)
    @grid[y][x]
  end

  def char(x, y)
    get(x, y)[:char]
  end
end

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

class GridTest < Minitest::Test
  def test_count
    io = File.open(__dir__ + '/sample.txt')
    grid = Grid.new(io)
    assert_equal 100, grid.count
  end

  def test_get
    io = File.open(__dir__ + '/sample.txt')
    grid = Grid.new(io)
    cell = grid.get(1, 1)
    assert_equal "@", cell[:char]
    assert_equal 1, cell[:x]
    assert_equal 1, cell[:y]
  end

  def test_char
    io = File.open(__dir__ + '/sample.txt')
    grid = Grid.new(io)
    assert_equal "@", grid.char(1, 1)
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
