#!/usr/bin/env ruby
require 'minitest'

# Receives "1-2,3-4" and returns [[1,2],[3,4]]
def split_section_assignment_pairs(string)
  string.split(',').map { |pair| pair.split('-').map(&:to_i) }
end

# Check to see if pair1 is inside pair2
def check_pair_inside_pair(pair1, pair2)
  pair1[0] >= pair2[0] && pair1[1] <= pair2[1]
end

# Checks two pairs of numbers to see if one encapsulates the other (in either direction)
def check_both_pairs(pair1, pair2)
  check_pair_inside_pair(pair1, pair2) || check_pair_inside_pair(pair2, pair1)
end

def check_for_all_overlaps(io)
  result = 0
  io.each_line do |line|
    result += 1 if check_both_pairs(*split_section_assignment_pairs(line))
  end
  result
end

class PairingTest < MiniTest::Test
  def test_split_section_assignment_pairs
    string = "2-4,6-8"
    assert_equal [[2, 4], [6, 8]], split_section_assignment_pairs(string)
  end

  def test_check_pair_inside_pair
    assert check_pair_inside_pair([2, 3], [1, 4])
    assert check_pair_inside_pair([1, 1], [1, 4])
    assert check_pair_inside_pair([4, 4], [1, 4])
    assert check_pair_inside_pair([4, 4], [4, 4])
    refute check_pair_inside_pair([1, 4], [2, 4])
    refute check_pair_inside_pair([1, 5], [1, 3])
  end

  def test_check_both_pairs
    assert check_both_pairs([2, 3], [1, 4])
    assert check_both_pairs([1, 1], [1, 4])
    assert check_both_pairs([4, 4], [1, 4])
    assert check_both_pairs([4, 4], [4, 4])
    assert check_both_pairs([1, 4], [2, 4])
    assert check_both_pairs([1, 4], [1, 3])
    refute check_both_pairs([1, 2], [3, 4])
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
    assert 2, check_for_all_overlaps(io)
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts check_for_all_overlaps(ARGF)
end
