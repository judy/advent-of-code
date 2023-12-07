#!/usr/bin/env ruby
require 'minitest'

class VisibleTrees
  attr_accessor :forest, :visible_trees
  def initialize(io)
    @forest, @visible_trees = process_forest(io)
  end

  def process_forest(io)
    forest = io.readlines(chomp: true).map { _1.chars.map(&:to_i) }
    visible_trees = Array.new(forest.size) { Array.new(forest[0].size, false) }
    [forest, visible_trees]
  end

  def externally_visible_trees_count
    visible_trees.map { _1.count(true) }.sum
  end

  def solve_axis
    forest.each_with_index do |row, x|
      row.each_with_index do |tree, y|
        next if visible_trees[x][y] # skip if already visible

        left = row[0...y]
        right = row[y+1..-1]
        visible_trees[x][y] = left.all? { _1 < tree } || right.all? { _1 < tree }
      end
    end

    self
  end

  def solve
    solve_axis
    @forest = forest.transpose
    @visible_trees = visible_trees.transpose
    solve_axis

    self
  end
end

class Test < MiniTest::Test
  def test_process_forest
    io = StringIO.new <<~STRING
      12
      34
    STRING
    assert_equal [[1, 2], [3, 4]], VisibleTrees.new(io).forest
  end

  def test_starting_visible_trees
    io = StringIO.new <<~STRING
      123
      456
    STRING
    assert_equal [[false, false, false], [false, false, false]], VisibleTrees.new(io).visible_trees
  end

  def test_solve_axis
    io = StringIO.new <<~STRING
      919
      191
      911
    STRING
    expected_visible_trees = [
      [true, false, true],
      [true, true, true],
      [true, false, true]
    ]
    assert_equal expected_visible_trees, VisibleTrees.new(io).solve_axis.visible_trees
  end

  def test_externally_visible_trees_count
    io = StringIO.new <<~STRING
      919
      191
      911
    STRING
    assert_equal 7, VisibleTrees.new(io).solve_axis.externally_visible_trees_count
  end

  def test_solve
    io = StringIO.new <<~STRING
      919
      919
      919
    STRING
    expected_visible_trees = [
      [true, true, true],
      [true, false, true],
      [true, true, true]
    ]
    assert_equal expected_visible_trees, VisibleTrees.new(io).solve.visible_trees
  end

  def test_example
    io = StringIO.new <<~STRING
      30373
      25512
      65332
      33549
      35390
    STRING
    expected = 21
    assert_equal expected, VisibleTrees.new(io).solve.externally_visible_trees_count
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts VisibleTrees.new(ARGF).solve.externally_visible_trees_count
end
