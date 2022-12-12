#!/usr/bin/env ruby
require 'minitest'

class Worm
  attr_accessor :head, :tail

  Position = Struct.new('Position', :x, :y)

  def initialize(hx: 0, hy: 0, tx: 0, ty: 0)
    @head = Position.new(hx, hy)
    @tail = Position.new(tx, ty)
  end

  def distance
    [(@head.x - @tail.x).abs, (@head.y - @tail.y).abs].max
  end

  def move(direction)
    former_head_position = [head.x, head.y]

    case direction
    when 'R'
      @head.x += 1
    when 'L'
      @head.x -= 1
    when 'U'
      @head.y += 1
    when 'D'
      @head.y -= 1
    else
      raise "unknown direction #{direction}"
    end

    if distance > 1
      tail.x, tail.y = former_head_position
    end

    self
  end
end

class Solver
  attr_accessor :io, :worm

  def initialize(io)
    @io = io
    @worm = Worm.new
  end

  def solve
    io.each do |line|
      direction, distance = line.split(' ')
      distance.to_i.times do
        worm.move(direction)
      end
    end

    self
  end
end

class WormTest < MiniTest::Test
  def test_new_worm
    worm = Worm.new
    assert_equal 0, worm.head.x
    assert_equal 0, worm.head.y
    assert_equal 0, worm.tail.x
    assert_equal 0, worm.tail.y
  end

  def test_distance
    assert_equal 0, Worm.new(hx: 0, hy: 0).distance
    assert_equal 1, Worm.new(hx: 1, hy: 0).distance
    assert_equal 1, Worm.new(hx: 0, hy: 1).distance
    assert_equal 1, Worm.new(hx: 1, hy: 1).distance
    assert_equal 2, Worm.new(hx: 2, hy: 1).distance
  end

  def test_move
    assert_equal 1, Worm.new.move('R').head.x
    assert_equal 0, Worm.new.move('R').head.y
  end

  def test_move_tail
    worm = Worm.new
    worm.move('R')
    assert_equal [0, 0], [worm.tail.x, worm.tail.y]
    worm.move('R')
    assert_equal [1, 0], [worm.tail.x, worm.tail.y]
  end

  def test_move_tail_diagonal
    worm = Worm.new(hx: 1, hy: 1)
    worm.move('R')
    assert_equal [1, 1], [worm.tail.x, worm.tail.y]
  end
end

class SolverTest < MiniTest::Test
  def test_simple_move
    io = StringIO.new <<~STRING
      R 2
      U 2
    STRING
    solver = Solver.new(io).solve
    worm = solver.worm
    assert_equal [2, 2], [worm.head.x, worm.head.y]
    assert_equal [2, 1], [worm.tail.x, worm.tail.y]
  end

  def test_example_position
    io = StringIO.new <<~STRING
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    STRING

    worm = Solver.new(io).solve.worm
    assert_equal [1, 2], [worm.tail.x, worm.tail.y]
  end

  def test_example
    skip
    io = StringIO.new <<~STRING
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    STRING
    expected_positions_visited = 13
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
