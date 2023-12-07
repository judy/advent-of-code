#!/usr/bin/env ruby
require 'minitest'

class Elf
  attr_reader :number, :calorie_count

  def initialize(number, calorie_count)
    @number = number
    @calorie_count = calorie_count
  end

  def <=>(other)
    @calorie_count <=> other.calorie_count
  end
end

class ElfCalorieProcessor
  def initialize(io)
    @io = io

    # initial state for processing
    @elves = []
    @elf_counter = 1
    @running_calorie_counter = 0
  end

  def process
    @io.each_line do |line|
      if line.to_i > 0 # number
        @running_calorie_counter = @running_calorie_counter + line.to_i
      else # empty line
        @elves << process_elf
      end
    end
    @elves << process_elf # In case there's one at the end with no newline
    @elves.sort!
  end

  private

  def process_elf
    elf = Elf.new(@elf_counter, @running_calorie_counter)
    @running_calorie_counter = 0
    @elf_counter += 1

    elf
  end
end

class ElfCalorieProcessorTest < MiniTest::Test
  def test_no_newline_at_end
    io = StringIO.new <<~STRING
      100
      200
      300
    STRING
    elves = ElfCalorieProcessor.new(io).process
    assert_equal [1, 600], [elves[-1].number, elves[-1].calorie_count]
  end

  def test_two_elves
    io = StringIO.new <<~STRING
      300

      200
    STRING
    elves = ElfCalorieProcessor.new(io).process
    assert_equal [1, 300], [elves[-1].number, elves[-1].calorie_count]
  end

  def test_actual_data
    io = StringIO.new <<~STRING
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    STRING
    elves = ElfCalorieProcessor.new(io).process
    assert_equal [4, 24_000], [elves[-1].number, elves[-1].calorie_count]
    assert_equal [3, 11_000], [elves[-2].number, elves[-2].calorie_count]
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  elves = ElfCalorieProcessor.new(ARGF).process

  puts "Elf #{elves[-1].number} has the most calories: #{elves[-1].calorie_count}"
  total = elves[-1].calorie_count + elves[-2].calorie_count + elves[-3].calorie_count
  puts "The top three have #{total} calories"
end
