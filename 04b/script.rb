#!/usr/bin/env ruby
require 'minitest'

# Receives "1-2,3-4" and returns [[1,2],[3,4]]
def split_section_assignment_pairs(string)
  string.split(',').map { |pair| pair.split('-').map(&:to_i) }
end

# Check to see if pair1 overlaps with pair2
def check_pairs_overlap(pair1, pair2)
  pair1[0] <= pair2[1] && pair1[1] >= pair2[0]
end

def check_for_any_overlaps(io)
  result = 0
  io.each_line do |line|
    result += 1 if check_pairs_overlap(*split_section_assignment_pairs(line))
  end
  result
end

class PairingTest < MiniTest::Test
  def test_split_section_assignment_pairs
    string = "2-4,6-8"
    assert_equal [[2, 4], [6, 8]], split_section_assignment_pairs(string)
  end

  def test_check_pairs_overlap
    assert check_pairs_overlap([2, 3], [1, 4])
    assert check_pairs_overlap([1, 1], [1, 4])
    assert check_pairs_overlap([4, 5], [1, 4])
    assert check_pairs_overlap([4, 5], [0, 4])
    refute check_pairs_overlap([1, 4], [0, 0])
  end

  def test_example_pairs
    io = StringIO.new <<~STRING
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
    STRING
    assert 4, check_for_any_overlaps(io)
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts check_for_any_overlaps(ARGF)
end
