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

  def test_example
    skip
    io = StringIO.new <<~STRING
      30373
      25512
      65332
      33549
      35390
    STRING
    expected = 21
    assert_equal expected, VisibleTrees.new(io).solve
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
