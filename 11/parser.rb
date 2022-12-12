#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require_relative 'monkey'

class MonkeyParser
  def initialize(io)
    @io = io
  end

  def parse
    monkey = Monkey.new
    monkey.number = monkey_string.match(/Monkey (?<number>\d+):/)['number'].to_i
    monkey.items = monkey_string.match(/Starting items: (?<items>.*)/)['items'].split(', ').map(&:to_i)
    monkey.operation = monkey_string.match(/Operation: new = (?<operation>.*)/)['operation']
    monkey.divisible_by = monkey_string.match(/Test: divisible by (?<divisible>\d+)/)['divisible'].to_i
    monkey.if_true = monkey_string.match(/If true: throw to monkey (?<monkey>\d+)/)['monkey'].to_i
    monkey.if_false = monkey_string.match(/If false: throw to monkey (?<monkey>\d+)/)['monkey'].to_i
    monkey
  end

  def monkey_string
    @monkey_string ||= @io.read
  end
end

class MonkeyParserTest < MiniTest::Test
  def test_parsing_single_monkey
    io = StringIO.new <<~STRING
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3
    STRING
    monkey = MonkeyParser.new(io).parse
    assert_equal 0, monkey.number
    assert_equal [79, 98], monkey.items
    assert_equal "old * 19", monkey.operation
    assert_equal 23, monkey.divisible_by
    assert_equal 2, monkey.if_true
    assert_equal 3, monkey.if_false
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
