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
    case direction
    when 'R' then @head.x += 1
    when 'L' then @head.x -= 1
    when 'U' then @head.y += 1
    when 'D' then @head.y -= 1
    else raise "unknown direction #{direction}"
    end

    self
  end
end

class Test < MiniTest::Test
  def test_new_worm
    worm = Worm.new
    assert_equal 0, worm.head.x
    assert_equal 0, worm.head.y
    assert_equal 0, worm.tail.x
    assert_equal 0, worm.tail.y
  end

  def test_start_position
    worm = Worm.new
    assert_equal [0, 0], [worm.head.x, worm.head.y]
    assert_equal [0, 0], [worm.tail.x, worm.tail.y]
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
