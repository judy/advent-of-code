#!/usr/bin/env ruby
require 'minitest'

class Ship
  attr_accessor :stacks
  def initialize(stacks)
    @stacks = stacks
  end

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

    stacks = {}
    lines.each do |line|
      next if line[0] == " " || line[0] == nil # skip up any "empty" arrays, eg. [nil, " ", " "]
      stack_name = line.shift
      stacks[stack_name] = clear_empties_from_end_of_array(line)
    end

    new(stacks)
  end

  def self.clear_empties_from_end_of_array(array)
    while array.last.nil? || array.last.strip.empty?
      array.pop
    end
    array
  end
end

class ShipTest < MiniTest::Test
  def test_new_ship_from_diagram
    ship_diagram = <<~STRING
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3
    STRING
    expected = {
      "1" => ['Z', 'N'],
      "2" => ['M', 'C', 'D'],
      "3" => ['P']
    }
    assert_equal expected, Ship.new_ship_from_diagram(ship_diagram).stacks
  end

  def test_clear_empties_from_end_of_array
    array_with_nils = ['Z', 'N', nil]
    array_with_spaces = ['Z', 'N', " "]
    assert_equal ['Z', 'N'], Ship.clear_empties_from_end_of_array(array_with_nils)
    assert_equal ['Z', 'N'], Ship.clear_empties_from_end_of_array(array_with_spaces)
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise 'no input handler yet'
end
