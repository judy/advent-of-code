#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'pry'

require_relative 'monkey'
require_relative 'parser'

class Solution
  attr_accessor :monkeys
  def initialize(io)
    @monkeys = MonkeyParser.parse_tribe(io)
    least_common_multiple = @monkeys.inject(1) { |multiple, monkey| multiple * monkey.divisible_by }
    @monkeys.each { |m| m.lcm = least_common_multiple }
  end

  def run_round
    monkeys.each do |monkey|
      while monkey.items.count > 0
        item = monkey.items.shift
        destination_monkey, new_item = monkey.process_item(item)
        monkeys[destination_monkey].items << new_item
      end
    end
  end

  def run_rounds(times = 20)
    puts
    times.times do |i|
      run_round
      print "#{i} "
    end

    puts "...complete!"
    self
  end

  def monkey_counts
    monkeys.map(&:processed_count)
  end

  def find_solution
    values = monkey_counts.sort.reverse
    values[0] * values[1]
  end
end

class SolutionTest < MiniTest::Test
  def test_example
    io = File.open(__dir__ + '/sample.txt')
    solution = Solution.new(io).run_rounds
    assert_equal 10605, solution.find_solution
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts Solution.new(ARGF).run_rounds(10_000).find_solution
end
