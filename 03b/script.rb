#!/usr/bin/env ruby
require 'minitest'

PRIORITIES = (("a".."z").to_a + ("A".."Z").to_a).zip((1..52).to_a).to_h

class ElfTrio
  attr_reader :badge
  def initialize(elf1, elf2, elf3)
    @badge = (elf1.chars & elf2.chars & elf3.chars).first
  end
end

def rucksack_checker(io)
  @result = 0
  io.readlines.each_slice(3) do |elf1, elf2, elf3|
    @result += PRIORITIES[ElfTrio.new(elf1, elf2, elf3).badge]
  end
  @result
end


class RucksackTest < MiniTest::Test
  def test_elftrio
    elf1 = "vJrwpWtwJgWrhcsFMMfFFhFp"
    elf2 = "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"
    elf3 = "PmmdzqPrVvPwwTWBwg"
    assert_equal "r", ElfTrio.new(elf1, elf2, elf3).badge
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
    assert_equal 70, rucksack_checker(io)
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts rucksack_checker(ARGF)
end
