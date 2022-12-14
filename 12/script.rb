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
        @maze.add_vertex(coords)

        # check left
        next if x == 0 # don't check for left vertex if we're at the left edge
        left_edge_coords = [x - 1, y]
        test_and_connect_edge(coords, left_edge_coords)

        # check up
        next if y == 0 # don't check for above vertex if we're at the top edge
        above_edge_coords = [x, y - 1]
        test_and_connect_edge(coords, above_edge_coords)
      end
    end
  end

  def test_and_connect_edge(edge1, edge2)
    edge1_value = check_value(matrix[edge1[1]][edge1[0]]) # takes x and y so we can store start and end
    edge2_value = check_value(matrix[edge2[1]][edge2[0]])
    connect = (edge1_value - edge2_value).abs <= 1
    @maze.add_edge(edge1, edge2) if connect
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
