#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Map
  include Enumerable

  attr_reader :map

  def initialize(map)
    @map = map
  end

  def each(&block)
    map.each(&block)
  end

  def width
    map.first.size
  end

  def height
    map.size
  end

  def at(x, y)
    return nil if x < 0
    return nil if y < 0
    return nil if x >= width
    return nil if y >= height

    map[y][x]
  end
end

class Solution
  attr_reader :io, :map
  def initialize(io)
    @io = io
    @map = Map.new(io.each_line.map(&:chomp).map(&:chars))
  end

  def solve(for_what: :xmas)
    total_xmas_count = 0
    map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        total_xmas_count += (for_what == :xmas ? look_for_xmas_at_position(x, y) : look_for_x_mas_at_position(x, y))
      end
    end

    total_xmas_count
  end

  def look_for_xmas_at_position(x, y)
    return 0 unless map.at(x, y) == 'X'
    xmas_count = 0

    # going right
    xmas_count += 1 if map.at(x + 1, y) == 'M' && map.at(x + 2, y) == 'A' && map.at(x + 3, y) == 'S'
    # going left
    xmas_count += 1 if map.at(x - 1, y) == 'M' && map.at(x - 2, y) == 'A' && map.at(x - 3, y) == 'S'
    # going up
    xmas_count += 1 if map.at(x, y - 1) == 'M' && map.at(x, y - 2) == 'A' && map.at(x, y - 3) == 'S'
    # going down
    xmas_count += 1 if map.at(x, y + 1) == 'M' && map.at(x, y + 2) == 'A' && map.at(x, y + 3) == 'S'
    # going up-right
    xmas_count += 1 if map.at(x + 1, y - 1) == 'M' && map.at(x + 2, y - 2) == 'A' && map.at(x + 3, y - 3) == 'S'
    # going up-left
    xmas_count += 1 if map.at(x - 1, y - 1) == 'M' && map.at(x - 2, y - 2) == 'A' && map.at(x - 3, y - 3) == 'S'
    # going down-right
    xmas_count += 1 if map.at(x + 1, y + 1) == 'M' && map.at(x + 2, y + 2) == 'A' && map.at(x + 3, y + 3) == 'S'
    # going down-left
    xmas_count += 1 if map.at(x - 1, y + 1) == 'M' && map.at(x - 2, y + 2) == 'A' && map.at(x - 3, y + 3) == 'S'

    xmas_count
  end

  def look_for_x_mas_at_position(x, y)
    return 0 unless map.at(x, y) == 'A'
    xmas_count = 0

    # up and down
    if    (map.at(x - 1, y) == 'M' && map.at(x + 1, y) == 'S') ||
          (map.at(x - 1, y) == 'S' && map.at(x + 1, y) == 'M')
       # check left and right
       if (map.at(x, y - 1) == 'M' && map.at(x, y + 1) == 'S') ||
          (map.at(x, y - 1) == 'S' && map.at(x, y + 1) == 'M')
         xmas_count += 1
       end
    end

    # diagonal top-left and bottom-right
    if    (map.at(x - 1, y - 1) == 'M' && map.at(x + 1, y + 1) == 'S') ||
          (map.at(x - 1, y - 1) == 'S' && map.at(x + 1, y + 1) == 'M')
       # check diagonal top-right and bottom-left
       if (map.at(x + 1, y - 1) == 'M' && map.at(x - 1, y + 1) == 'S') ||
          (map.at(x + 1, y - 1) == 'S' && map.at(x - 1, y + 1) == 'M')
         xmas_count += 1
       end
    end

    xmas_count
  end
end

class SolutionTest < Minitest::Test
  def test_example_xmas
    io = File.open(__dir__ + '/sample.txt', chomp: true)
    solution = Solution.new(io).solve
    expected = 18
    assert_equal expected, solution
  end
  def test_example_x_mas
    io = File.open(__dir__ + '/sample.txt', chomp: true)
    solution = Solution.new(io).solve(for_what: :x_mas)
    expected = 9
    assert_equal expected, solution
  end

  def test_going_right
    io = StringIO.new "12XMAS34"
    solution = Solution.new(io).solve
    expected = 1
    assert_equal expected, solution
  end

  def test_map_at
    map = Map.new(
      [[1, 2, 3],
       [4, 5, 6],
       [7, 8, 9]]
    )
    assert_equal 1, map.at(0, 0)
    assert_equal 4, map.at(0, 1)
    assert_equal 2, map.at(1, 0)
    assert_equal 5, map.at(1, 1)

    assert_nil map.at(-1, 0)
    assert_nil map.at(0, -1)
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve(for_what: :x_mas)
end
