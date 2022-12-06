#!/usr/bin/env ruby
require 'minitest'

PRIORITIES = (("a".."z").to_a + ("A".."Z").to_a).zip((1..52).to_a).to_h

def split_string(string)
  [string[0..(string.length / 2 - 1)], string[(string.length / 2)..-1]]
end

class Rucksack
  attr_reader :comp1, :comp2
  def initialize(item_string)
    @comp1, @comp2 = split_string(item_string).map { _1.chars }
  end

  def find_match
    (@comp1 & @comp2).first
  end
end

def rucksack_checker(io)
  @result = 0
  io.each_line do |line|
    item = Rucksack.new(line.chomp).find_match
    @result += PRIORITIES[item]
  end
  @result
end


class RucksackTest < MiniTest::Test
  def test_split_string
    assert_equal ["a", "b"], split_string("ab")
    assert_equal ["hello", "world"], split_string("helloworld")
    assert_equal ["he", "llo"], split_string("hello") # what to do in odd situations?
  end

  def test_rucksack_string_splitting
    item_string = "vJFp"
    assert_equal ["v", "J"], Rucksack.new(item_string).comp1
  end

  def test_rucksack_process
    item_string = "vJrwpWtwJgWrhcsFMMfFFhFp"
    assert_equal "p", Rucksack.new(item_string).find_match
  end

  def test_rucksack_checker
    io = StringIO.new <<~STRING
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
    STRING
    assert_equal 157, rucksack_checker(io)
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts rucksack_checker(ARGF)
end
