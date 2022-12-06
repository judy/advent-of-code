#!/usr/bin/env ruby
require 'minitest'

class Ship
  attr_accessor :stacks

  # Takes a ship diagram in the form of:
  #
  #       [D]
  #   [N] [C]
  #   [Z] [M] [P]
  #    1   2   3
  #
  # and returns a hash of stacks, in the form of:
  #
  #   {
  #     1 => ['Z', 'N'],
  #     2 => ['M', 'C', 'D'],
  #     3 => ['P']
  #   }
  #
  # This could be a numbered array, but I want to be prepared for any curveballs,
  # like a stack having a name instead of a numerical designation.
  def self.new_ship_from_diagram(ship_diagram)
    # convert into arrays of chars
    lines = ship_diagram.gsub(/[\[\]]/, ' ').split("\n").map(&:chars)

    # safe transpose, then reverse arrays so stack numbers are at front
    max_length = lines.map(&:length).max
    lines = lines.map{|e| e.values_at(0...max_length)}.transpose.map(&:reverse)

    stacks = []
    lines.each_with_index do |line, index|
      next if line[0] == " " || line[0] == nil # skip up any "empty" arrays, eg. [nil, " ", " "]

      line.shift # clear number from front
      stacks << clear_empties_from_end_of_array(line)
    end

    new(stacks)
  end

  def self.clear_empties_from_end_of_array(array)
    while array.last.nil? || array.last.strip.empty?
      array.pop
    end
    array
  end

  def initialize(stacks)
    @stacks = stacks
  end

  def move_crates(count, from, to)
    # get rid of those nasty off-by-one errors before they happen...
    from -= 1
    to -= 1
    # Move each crate one at a time
    count.times { stacks[to].push(stacks[from].pop) }
  end

  def move_crates_by_verbal_command(command)
    m = /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/.match(command)
    move_crates(m[:count].to_i, m[:from].to_i, m[:to].to_i)
  end
end

class ChiefMate
  attr_reader :transport_document
  def initialize(transport_document)
    @transport_document = transport_document
  end

  def process_transport_document
    ship_diagram, verbal_commands = transport_document.read.split("\n\n")

    ship = Ship.new_ship_from_diagram(ship_diagram)
    verbal_commands.split("\n").each do |command|
      ship.move_crates_by_verbal_command(command)
    end
    ship
  end
end

class ShipTest < MiniTest::Test
  attr_accessor :ship

  def setup
    @ship = Ship.new([['A'], ['B', 'C'], ['D']])
  end

  def test_new_ship_from_diagram
    ship_diagram = <<~STRING
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3
    STRING
    expected = [
      ['Z', 'N'],
      ['M', 'C', 'D'],
      ['P']
    ]
    assert_equal expected, Ship.new_ship_from_diagram(ship_diagram).stacks
  end

  def test_clear_empties_from_end_of_array
    array_with_nils = ['Z', 'N', nil]
    array_with_spaces = ['Z', 'N', " "]
    assert_equal ['Z', 'N'], Ship.clear_empties_from_end_of_array(array_with_nils)
    assert_equal ['Z', 'N'], Ship.clear_empties_from_end_of_array(array_with_spaces)
  end

  def test_move_crates
    ship.move_crates(1, 1, 2)
    assert_equal [[], ['B', 'C', 'A'], ['D']], ship.stacks
    ship.move_crates(2, 2, 3)
    assert_equal [[], ['B'], ['D', 'A', 'C']], ship.stacks
  end

  def test_move_crates_by_verbal_command
    ship.move_crates_by_verbal_command("move 1 from 1 to 2")
    assert_equal [[], ['B', 'C', 'A'], ['D']], ship.stacks
    ship.move_crates_by_verbal_command("move 2 from 2 to 3")
    assert_equal [[], ['B'], ['D', 'A', 'C']], ship.stacks
  end
end

class ChiefMateTest < MiniTest::Test
  def test_processing_of_transport_document
    io = StringIO.new <<~STRING
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
    STRING
    expected = [
      ['C'],
      ['M'],
      ['P', 'D', 'N', 'Z']
    ]
    ship = ChiefMate.new(io).process_transport_document
    assert_equal expected, ship.stacks
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise 'no input handler yet'
end
