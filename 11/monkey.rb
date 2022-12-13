#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

class Monkey
  attr_accessor :number, :items, :operation, :test, :divisible_by, :if_true, :if_false, :processed_count

  def initialize
    @processed_count = 0
  end

  def process_items
  end

  def process_item(item)
    @processed_count += 1
    old = item
    item = eval(operation)
    item = item / 3
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
    result = monkey.process_item(79)
    assert_equal [3, 500], result
  end
end

if ARGV[0] == 'test'
  MiniTest.run
end