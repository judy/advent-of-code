#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Grid
  include Enumerable

  # NOTE: Assumes every line is the same length
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
    return to_enum(:each) unless block_given?

    @grid.each do |row|
      row.each do |cell|
        yield cell
      end
    end
  end

  def get(x, y)
    if y < 0 ||
       y >= @grid.size ||
       x < 0 ||
       x >= @grid[0].size
      return { char: nil, x:, y: }
    end

    @grid[y][x]
  end

  def neighbors(x, y)
    [
        get(x - 1, y - 1), # top-left
        get(x,     y - 1), # top
        get(x + 1, y - 1), # top-right
        get(x - 1, y    ), # left
      # get(x    , y    ), # center, not a neighbor
        get(x + 1, y    ), # right
        get(x - 1, y + 1), # bottom-left
        get(x,     y + 1), # bottom
        get(x + 1, y + 1) # bottom-right
    ]
  end

  def char(x, y)
    get(x, y)[:char]
  end
end


class GridTest < Minitest::Test
  attr_reader :io, :grid

  def setup
    @io = StringIO.new(<<~GRID)
      ..@@.@@@@.
      @@@.@.@.@@
      @@@@@.@.@@
      @.@@@@..@.
      @@.@@@@.@@
      .@@@@@@@.@
      .@.@.@.@@@
      @.@@@.@@@@
      .@@@@@@@@.
      @.@.@@@.@.
    GRID
    @grid = Grid.new(@io)
  end

  def test_count
    assert_equal 100, grid.count
  end

  def test_get
    cell = grid.get(1, 1)
    assert_equal "@", cell[:char]
    assert_equal 1, cell[:x]
    assert_equal 1, cell[:y]
  end

  def test_get_out_of_bounds
    assert_nil grid.get(-1, 0)[:char]
    assert_nil grid.get(0, -1)[:char]
    assert_nil grid.get(0, 10)[:char]
    assert_nil grid.get(10, 10)[:char]
  end

  def test_char
    assert_equal "@", grid.char(1, 1)
  end

  def test_neighbors
    expected_chars = [
      ".", ".", "@",
      "@",      "@",
      "@", "@", "@"
    ]
    assert_equal expected_chars, get_neighbor_chars(1, 1)
  end

  def test_neighbors_oob_top_left
    expected_chars = [
      nil, nil, nil,
      nil,      ".",
      nil, "@", "@"
    ]
    assert_equal expected_chars, get_neighbor_chars(0, 0)
  end

  def test_neighbors_oob_bottom_right
    expected_chars = [
      "@", ".", nil,
      "@",      nil,
      nil, nil, nil
    ]
    assert_equal expected_chars, get_neighbor_chars(9, 9)
  end

  private

  def get_neighbor_chars(x, y)
    grid.neighbors(x, y).map { |cell| cell[:char] }
  end
end

if ARGV[0] == 'test'
  Minitest.run
end
