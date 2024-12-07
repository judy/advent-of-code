#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'
require 'tty-cursor'

Guard = Struct.new(:x, :y, :direction, :on_map)

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

  def set(x, y, value)
    map[y][x] = value
  end
end

class Solution
  attr_reader :io, :map, :guard, :cursor, :timeout
  def initialize(io)
    @io = io
    @map = Map.new(io.each_line.map(&:chomp).map(&:chars))
    @cursor = TTY::Cursor
    @timeout = 0
  end

  def solve
    print cursor.clear_screen_down
    @guard = set_guard

    while guard.on_map
      @timeout += 1
      draw_map
      move_guard
      guard.on_map = false if timeout > 100_000_000
    end

    count_squares = count_path_squares
    puts "Path squares: #{count_squares}"
    count_squares
  end

  def move_guard
    if guard.direction == :up
      if map.at(guard.x, guard.y - 1) == '#'
        guard.direction = :right
      elsif map.at(guard.x, guard.y - 1).nil?
        guard.on_map = false
        return
      else
        map.set(guard.x, guard.y, 'X')
        guard.y -= 1
        map.set(guard.x, guard.y, '^')
        return
      end
    end

    if guard.direction == :right
      if map.at(guard.x + 1, guard.y) == '#'
        guard.direction = :down
      elsif map.at(guard.x + 1, guard.y).nil?
        guard.on_map = false
        return
      else
        map.set(guard.x, guard.y, 'X')
        guard.x += 1
        map.set(guard.x, guard.y, '>')
        return
      end
    end

    if guard.direction == :down
      if map.at(guard.x, guard.y + 1) == '#'
        guard.direction = :left
      elsif map.at(guard.x, guard.y + 1).nil?
        guard.on_map = false
        return
      else
        map.set(guard.x, guard.y, 'X')
        guard.y += 1
        map.set(guard.x, guard.y, 'V')
        return
      end
    end

    if guard.direction == :left
      if map.at(guard.x - 1, guard.y) == '#'
        guard.direction = :up
      elsif map.at(guard.x - 1, guard.y).nil?
        guard.on_map = false
        return
      else
        map.set(guard.x, guard.y, 'X')
        guard.x -= 1
        map.set(guard.x, guard.y, '<')
        return
      end
    end
  end

  def draw_map
    print cursor.save
    print cursor.down(4)
    puts "Guard: #{sprintf("%3d", guard.x)}, #{sprintf("%3d", guard.y)} - Timeout: #{sprintf("%9d", timeout)}"
    (guard.y-25..guard.y+25).each do |y|
      (guard.x-25..guard.x+25).each do |x|
        char = map.at(x, y)
        if char.nil? || char == '.'
          print '  '
        else
          print char
          print ' '
        end
      end
      puts
    end
    print cursor.restore
  end

  def count_path_squares
    # add one at the end for going off screen :p
    map.inject(0) {|sum, row| row.count('X') + sum} + 1
  end

  def set_guard
    map.each_with_index do |row, y|
      row.each_with_index do |char, x|
        if char == '^'
          return Guard.new(x, y, :up, true)
        end
      end
    end
  end
end

class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 41
    assert_equal expected, solution
  end

  def test_set_guard
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io)
    guard = solution.set_guard
    assert_equal 4, guard.x
    assert_equal 6, guard.y
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
