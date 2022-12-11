#!/usr/bin/env ruby
require 'minitest'

class VisibleTrees
  attr_accessor :forest
  def initialize(io)
    @forest = process_forest(io)
  end

  def process_forest(io)
    io.readlines(chomp: true).map { _1.chars.map(&:to_i) }
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
