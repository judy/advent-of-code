#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require 'pry-byebug'

class ComparableArray < Array
  include Comparable
  def <=>(other)
    left = ComparableArray[*self]
    right = ComparableArray[*other]
    # return 0 if left == right
    while true
      return -1 if left.empty?
      return 1 if right.empty?
      left[0] = ComparableArray[*left[0]] if left[0].kind_of?(Array)
      right[0] = ComparableArray[*right[0]] if right[0].kind_of?(Array)
      result = ComparableArray[*left.first] <=> ComparableArray[*right.first] if (left.first.kind_of?(Array) ^ right.first.kind_of?(Array))
      if result == 0
        left.shift
        right.shift
        next
      elsif result != nil
        return result
      end
      return -1 if left.first < right.first
      return 1 if left.first > right.first
      left.shift
      right.shift
    end
  end
end

class ComparableArrayTest < MiniTest::Test
  def test_compare
    assert_equal -1, ComparableArray.new([1,1,3,1,1]) <=> ComparableArray.new([1,1,5,1,1])
    assert_equal -1, ComparableArray.new([[1],[2,3,4]]) <=> ComparableArray.new([[1],4])
    assert_equal 1, ComparableArray.new([9]) <=> ComparableArray.new([[8,7,6]])
    assert_equal -1, ComparableArray.new([[4,4],4,4]) <=> ComparableArray.new([[4,4],4,4,4])
    assert_equal 1, ComparableArray.new([7,7,7,7]) <=> ComparableArray.new([7,7,7])
    assert_equal -1, ComparableArray.new([]) <=> ComparableArray.new([3])
    assert_equal 1, ComparableArray.new([1,[2,[3,[4,[5,6,7]]]],8,9]) <=> ComparableArray.new([1,[2,[3,[4,[5,6,0]]]],8,9])
  end
end

class Solution
  attr_reader :io, :orders
  def initialize(io)
    @io = io
    @orders = []

  end

  def solve
    @indice_sum = 0
    pairs.each do |pair|
      @orders << (pair[0] <=> pair[1])
    end
    @orders.each_with_index do |order, i|
      i += 1
      @indice_sum += i if order == -1
    end
    puts "Indice sum: #{@indice_sum}"
    self
  end

  def pairs
    @pairs ||= begin
      pairs = io.read.split("\n\n").map { _1.chomp.split("\n") }
      pairs.map { |p| p.map { ComparableArray.new(eval(_1)) } }
    end
  end
end

class SolutionTest < MiniTest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).solve
    expected = 13
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts Solution.new(ARGF).solve.orders.join(' ')
end
