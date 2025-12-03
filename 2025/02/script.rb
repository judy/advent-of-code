#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class Solution
  attr_reader :io
  def initialize(io)
    @io = io
  end

  def solve
    input = io.each_line.first # Input should only be on one line!
    numbers_to_scan = []
    sets = input.split(',')
    puts "Found #{sets.length} sets"
    sets.each do |set|
      range = set.split('-').map(&:to_i)
      numbers_to_scan.concat((range[0]..range[1]).to_a)
    end
    puts "Scanning #{numbers_to_scan.length} numbers"
    filtered = numbers_to_scan.select { |n| check_number(n) }
    filtered.sum
  end

  # True if input integer is *only* made of repeating digits or sets of digits, twice
  def check_number(n)
    n = n.to_s
    max_size = n.length / 2
    (1..max_size).each do |size|
      pattern = n[0, size]
      return true if n == pattern * 2
    end
    return false
  end
end

class SolutionTest < Minitest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 1227775554
    assert_equal expected, solution
  end

  def test_check_number
    solution = Solution.new(nil)
    assert_equal true, solution.check_number(11), "11 was incorrect"
    assert_equal false, solution.check_number(20), "20 was incorrect"
    assert_equal true, solution.check_number(22), "22 was incorrect"
    assert_equal true, solution.check_number(99), "99 was incorrect"
    assert_equal true, solution.check_number(1010), "1010 was incorrect"
    assert_equal true, solution.check_number(1188511885), "1188511885 was incorrect"
    assert_equal true, solution.check_number(222222), "222222 was incorrect"
    assert_equal true, solution.check_number(446446), "446446 was incorrect"
    assert_equal false, solution.check_number(1698522), "1698522 was incorrect"
    assert_equal false, solution.check_number(1698528), "1698528 was incorrect"
    assert_equal true, solution.check_number(38593859), "38593859 was incorrect"
    assert_equal false, solution.check_number(565656), "565656 was incorrect" # only repeated twice
  end
end

if ARGV[0] == 'test'
  Minitest.run
else
  puts Solution.new(ARGF).solve
end
