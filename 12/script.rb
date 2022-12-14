#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

require 'rgl/adjacency'

class MazeFinder
  attr_reader :maze
  def initialize(io)
    @io = io
    @maze = RGL::AdjacencyGraph.new
    convert_to_maze
  end

  def convert_to_maze
    matrix.each_with_index do |line, y|
      line.each_with_index do |char, x|
        coords = [x, y]
        @start ||= coords if char == 'S'
        @end   ||= coords if char == 'E'
        value = check_value(char) # takes x and y so we can store start and end
        @maze.add_vertex(coords)

        # check left
        next if x == 0 # don't check for left vertex if we're at the left edge
        left_edge_coords = [x - 1, y]
        left_edge_value = check_value(matrix[left_edge_coords[1]][left_edge_coords[0]])
        connect = (left_edge_value - value).abs <= 1
        @maze.add_edge(coords, left_edge_coords) if connect

        # check up
        next if y == 0 # don't check for above vertex if we're at the top edge
        above_edge_coords = [x, y - 1]
        above_edge_value = check_value(matrix[above_edge_coords[1]][above_edge_coords[0]])
        connect = (above_edge_value - value).abs <= 1
        @maze.add_edge(coords, above_edge_coords) if connect
      end
    end
  end

  def matrix
    @matrix ||= @io.readlines.map(&:chomp).map(&:chars)
  end

  def solve
    # 1. Find the start point
    # 2. Find the end point
    # 3. Find the shortest path
    # 4. Return the length of the shortest path
  end

  def check_value(char)
    value = case char
    when 'S'
      'a'.ord
    when 'E'
      'z'.ord
    else
      char.ord
    end
    value - 97 # convert 'a' in ascii, which is 97, to 0
  end
end

class MazeFinderTest < MiniTest::Test
  def test_small_example
    io = StringIO.new <<~STRING
      Sab
      zzc
      Eed
    STRING
    maze_finder = MazeFinder.new(io)
    expected = 6
  end

  def test_given_example
    skip
    io = StringIO.new <<~STRING
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    STRING
    expected = 31
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  # raise "unused"
  # puts MazeFinder.new(ARGF).solve
end
