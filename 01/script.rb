#!/usr/bin/env ruby
require 'minitest'

class Elf
  attr_reader :number, :calorie_count
  def initialize(number, calorie_count)
    @number = number
    @calorie_count = calorie_count
  end
end

class ElfCalorieProcessor
  def initialize(io)
    @io = io

    # initial state for processing
    @winning_elf = Elf.new(0, 0)
    @elf_counter = 1
    @running_calorie_counter = 0
  end

  def process
    @io.each_line do |line|
      if line.to_i > 0 # number
        @running_calorie_counter = @running_calorie_counter + line.to_i
      else # empty line
        process_elf
      end
    end
    process_elf # In case there's one at the end with no newline
    [@winning_elf.number, @winning_elf.calorie_count]
  end

  private

  def process_elf
    if @running_calorie_counter > @winning_elf.calorie_count
      @winning_elf = Elf.new(@elf_counter, @running_calorie_counter)
    end
    @running_calorie_counter = 0
    @elf_counter += 1
  end
end

class ElfCalorieProcessorTest < MiniTest::Test
  def test_line_output
    io = StringIO.new <<~STRING
      100
      200
      300

    STRING
    processor = ElfCalorieProcessor.new(io).process
    assert_equal [1, 600], processor
  end

  def test_no_newline_at_end
    io = StringIO.new <<~STRING
      100
      200
      300
    STRING
    processor = ElfCalorieProcessor.new(io).process
    assert_equal [1, 600], processor
  end

  def test_two_elves
    io = StringIO.new <<~STRING
      300

      200
    STRING
    processor = ElfCalorieProcessor.new(io).process
    assert_equal [1, 300], processor
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
    processor = ElfCalorieProcessor.new(io).process
    assert_equal [4, 24_000], processor
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  result_elf = ElfCalorieProcessor.new(ARGF).process

  puts "Elf #{result_elf[0]} has the most calories: #{result_elf[1]}"
end
