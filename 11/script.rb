#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

class MonkeyParser
  def initialize(io)
    @io = io
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
    monkey = MonkeyParser.new(io)
  end

  def test_example
    skip
    io = File.open(__dir__ + '/sample.txt')
    expected = 10605
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
  # puts Solution.new(ARGF).solve
end
