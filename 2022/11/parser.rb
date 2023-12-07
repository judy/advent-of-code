#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'
require_relative 'monkey'

class MonkeyParser
  def self.parse_tribe(io)
    io.read.split("\n\n").map do |monkey_string|
      MonkeyParser.new(StringIO.new(monkey_string)).parse
    end
  end

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

  def test_parsing_tribe
    io = StringIO.new <<~STRING
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3

      Monkey 1:
        Starting items: 54, 65, 75, 74
        Operation: new = old + 6
        Test: divisible by 19
          If true: throw to monkey 2
          If false: throw to monkey 0
    STRING
    monkeys = MonkeyParser.parse_tribe(io)

    assert_equal 0, monkeys[0].number
    assert_equal [79, 98], monkeys[0].items
    assert_equal "old * 19", monkeys[0].operation
    assert_equal 23, monkeys[0].divisible_by
    assert_equal 2, monkeys[0].if_true
    assert_equal 3, monkeys[0].if_false

    assert_equal 1, monkeys[1].number
    assert_equal [54, 65, 75, 74], monkeys[1].items
    assert_equal "old + 6", monkeys[1].operation
    assert_equal 19, monkeys[1].divisible_by
    assert_equal 2, monkeys[1].if_true
    assert_equal 0, monkeys[1].if_false
  end
end

if ARGV[0] == 'test'
  MiniTest.run
end
