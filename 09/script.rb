#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'tty-cursor'
require 'pry'

CURSOR = TTY::Cursor
TTYOUTPUT = File.open('/dev/ttys002', 'w+')
print CURSOR.move_to(0, 0)
print CURSOR.save

class Position
  attr_accessor :x, :y
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def to_s
    "(#{x}, #{y})"
  end
end

class Worm
  attr_accessor :head, :sections, :tail_history

  def initialize(hx: 0, hy: 0, sections: 1)
    @head = Position.new(hx, hy)
    @sections = Array.new(sections, Position.new(0, 0))
    @tail_history = { "0" => [0] }
  end

  def distance(a = head, b = tail)
    [(a.x - b.x).abs, (a.y - b.y).abs].max
  end

  def draw
    # print CURSOR.save
    TTYOUTPUT.print CURSOR.clear_screen

    # print history
    @tail_history.each do |x, ys|
      ys.each do |y|
        TTYOUTPUT.print CURSOR.move_to(x.to_i+100, y+15)
        TTYOUTPUT.print '.'
      end
    end

    # print sections
    sections.reverse.each_with_index do |section, i|
      TTYOUTPUT.print CURSOR.move_to(section.x+100, section.y+15)
      TTYOUTPUT.print i == 0 ? 0 : 10 - i
    end

    # print head
    TTYOUTPUT.print CURSOR.move_to(head.x+100, head.y+15)
    TTYOUTPUT.print 'X'

    TTYOUTPUT.print CURSOR.move_to(0, 0)
    # print CURSOR.restore
    sleep 0.2
  end

  def move(direction)
    former_head_position = Position.new(head.x, head.y)

    case direction
    when 'R'
      head.x += 1
    when 'L'
      head.x -= 1
    when 'U'
      head.y -= 1 # MIRRORED! Output should be the same!
    when 'D'
      head.y += 1 # MIRRORED! Output should be the same!
    else
      raise "unknown direction #{direction}"
    end

    move_rest_of_tail(former_head_position)

    draw

    self
  end

  def tail
    sections.last
  end

  def move_rest_of_tail(moved_position)
    new_position = head
    sections.each_with_index do |section, i|
      # puts "new_position: #{new_position} moved_position: #{moved_position} section: #{section}"
      if distance(new_position, section) > 1
        sections[i] = Position.new(moved_position.x, moved_position.y)
        moved_position = section
      else
        break
      end
    end

    @tail_history[tail.x.to_s] ||= []
    @tail_history[tail.x.to_s] = @tail_history[tail.x.to_s] | [tail.y]
  end

  def tail_positions_visited
    @tail_history.values.flatten.count
  end
end

class Solver
  attr_accessor :io, :worm

  def initialize(io, sections: 1)
    @io = io
    @worm = Worm.new(sections: sections)
  end

  def solve
    io.each_with_index do |line, i|
      # puts line
      # puts worm.tail_positions_visited
      # print CURSOR.move(0, 0)
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
    worm.move('U')
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

  def test_tail_history
    io = StringIO.new <<~STRING
      R 2
      U 2
    STRING
    worm = Solver.new(io).solve.worm
    expected = {'0'=>[0], '1'=>[0], '2'=>[1]}
    assert_equal expected, worm.tail_history
  end

  def test_tail_positions_visited
    io = StringIO.new <<~STRING
      R 2
      U 2
    STRING
    worm = Solver.new(io).solve.worm
    assert_equal 3, worm.tail_positions_visited
  end

  def test_tail_positions_visited_with_multiple_sections
    io = StringIO.new <<~STRING
      R 2
      U 2
    STRING
    worm = Solver.new(io, sections: 2).solve.worm
    assert_equal 2, worm.tail_positions_visited
  end

  def test_example
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
    worm = Solver.new(io).solve.worm
    assert_equal expected_positions_visited, worm.tail_positions_visited
  end

  focus
  def test_larger_example
    io = StringIO.new <<~STRING
      R 5
      U 8
    STRING
    expected_positions_visited = 36
    worm = Solver.new(io, sections: 9).solve.worm
    assert_equal expected_positions_visited, worm.tail_positions_visited
  end

  def test_largest_example
    io = StringIO.new <<~STRING
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    STRING
    expected_positions_visited = 36
    worm = Solver.new(io, sections: 9).solve.worm
    assert_equal expected_positions_visited, worm.tail_positions_visited
  end

end

if ARGV[0] == 'test'
  MiniTest.run
else
  worm = Solver.new(ARGF, sections: 9).solve.worm
  # puts worm.tail_history.inspect
  puts worm.tail_positions_visited
end

# it's not 5890, too high