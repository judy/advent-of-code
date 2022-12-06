#!/usr/bin/env ruby
require 'minitest'

class Ship
  def self.clear_empties_from_end_of_array(array)
    while array.last.nil? || array.last.strip.empty?
      array.pop
    end
    array
  end
end

class ShipTest < MiniTest::Test

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
