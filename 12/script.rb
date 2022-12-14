#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

require 'rgl/adjacency'
require 'rgl/dijkstra'

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
        if x != 0 # skip left edge
          left_edge_coords = [x - 1, y]
          test_and_connect_edge(coords, left_edge_coords)
        end

        # check up
        if y != 0 # skip top edge
          above_edge_coords = [x, y - 1]
          test_and_connect_edge(coords, above_edge_coords)
        end
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

  def solve(start_vertex: @start, end_vertex: @end)
    @edge_weights_lambda = lambda { |_| 1 }
    @shortest_path = @maze.dijkstra_shortest_path(@edge_weights_lambda, start_vertex, end_vertex)
    @shortest_path.length - 1
  rescue NoMethodError
    binding.pry
  end

  # def edge_weights
  #   @edge_weights = @maze.edges.each_with_object({}) do |edge, hash|
  #     hash[edge] = 1
  #   end
  # end

  def check_value(char)
    case char
    when 'S'
      'a'.ord
    when 'E'
      'z'.ord
    else
      char.ord
    end
  end
end

class MazeFinderTest < MiniTest::Test
  def test_small_example
    io = StringIO.new <<~STRING
      Sab
      zzc
      fed
    STRING
    expected = 6

    maze_finder = MazeFinder.new(io)
    assert_equal expected, maze_finder.solve(end_vertex: [0, 2])
  end

  def test_level_example
    io = StringIO.new <<~STRING
      Saa
      zza
      aaa
    STRING
    expected = 6

    maze_finder = MazeFinder.new(io)
    assert_equal expected, maze_finder.solve(end_vertex: [0, 2])
  end

  def test_oppposite_level_example
    io = StringIO.new <<~STRING
      aaa
      zza
      Saa
    STRING
    expected = 6

    maze_finder = MazeFinder.new(io)
    assert_equal expected, maze_finder.solve(end_vertex: [0, 0])
  end

  def test_given_example
    io = StringIO.new <<~STRING
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    STRING
    expected = 31

    maze_finder = MazeFinder.new(io)
    assert_equal expected, maze_finder.solve
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts MazeFinder.new(ARGF).solve
end
