#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pastel'

require 'rgl/adjacency'
require 'rgl/dijkstra'

class MazeFinder
  attr_reader :maze
  def initialize(io)
    @io = io
    @maze = RGL::DirectedAdjacencyGraph.new
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

  def find_scenic_route
    best_starting_point = [nil, nil]
    least_steps = Float::INFINITY
    matrix.each_with_index do |line, y|
      line.each_with_index do |char, x|
        next unless char == 'a'

        steps = solve(start_vertex: [x, y], end_vertex: @end)
        if steps < least_steps
          least_steps = steps
          best_starting_point = [x, y]
        end
      end
    end
    puts
    puts "Best route: #{best_starting_point}"
    puts "Least steps: #{least_steps}"
    solve(start_vertex: best_starting_point, end_vertex: @end)
    visualize
  end

  def test_and_connect_edge(edge1, edge2)
    edge1_value = check_value(matrix[edge1[1]][edge1[0]]) # takes x and y so we can store start and end
    edge2_value = check_value(matrix[edge2[1]][edge2[0]])
    @maze.add_edge(edge2, edge1) if (edge1_value - edge2_value) <= 1
    @maze.add_edge(edge1, edge2) if (edge2_value - edge1_value) <= 1
  end

  def matrix
    @matrix ||= @io.readlines.map(&:chomp).map(&:chars)
  end

  def solve(start_vertex: @start, end_vertex: @end)
    @edge_weights_lambda = lambda { |_| 1 }
    @shortest_path = @maze.dijkstra_shortest_path(@edge_weights_lambda, start_vertex, end_vertex)
    @shortest_path.nil? ? Float::INFINITY : @shortest_path.length - 1
  end

  def visualize
    @pastel = Pastel.new
    matrix.each_with_index do |line, y|
      line.each_with_index do |char, x|
        print @shortest_path.include?([x, y]) ? @pastel.green(char) : char
      end
      print "\n"
    end
  end

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
  mf = MazeFinder.new(ARGF)
  puts mf.solve
  mf.visualize
  mf.find_scenic_route
end
