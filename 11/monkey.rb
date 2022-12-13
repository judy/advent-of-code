#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

class Monkey
  attr_accessor :number, :items, :operation, :test, :divisible_by, :if_true, :if_false, :lcm, :processed_count

  def initialize
    @processed_count = 0
  end

  def process_item(item)
    @processed_count += 1
    old = item
    item = eval(operation)
    # item = item / 3 # HYSTERIA
    item = item % @lcm

    destination_monkey = (item % divisible_by == 0) ? if_true : if_false
    [destination_monkey, item]
  end
end

class MonkeyTest < MiniTest::Test
  def test_process_item
    monkey = Monkey.new
    monkey.operation = "old * 19"
    monkey.divisible_by = 23
    monkey.if_true = 2
    monkey.if_false = 3
    monkey.lcm = 23
    result = monkey.process_item(79)
    assert_equal [3, 65], result
  end
end

if ARGV[0] == 'test'
  MiniTest.run
end