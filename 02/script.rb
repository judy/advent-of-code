#!/usr/bin/env ruby
require 'minitest'

class ElfRPS
  SCENARIOS = {
    # A Rock, B Paper, C Scissors
    # X lose, Y draw, Z win
    "B X" => 1, # rock + 0 lose
    "C X" => 2, # paper + 0 lose
    "A X" => 3, # scissors + 0 lose
    "A Y" => 4, # rock + 3 draw
    "B Y" => 5, # paper + 3 draw
    "C Y" => 6, # scissors + 3 draw
    "C Z" => 7, # rock + 6 win
    "A Z" => 8, # paper + 6 win
    "B Z" => 9  # scissors + 6 win
  }
  def initialize(io)
    @io = io
    @score = 0
  end

  def process
    @io.each_line do |line|
      @score += SCENARIOS[line.chomp]
    end

    @score
  end
end


class ElfRPSTest < MiniTest::Test
  def test_actual_data
    io = StringIO.new <<~STRING
      A Y
      B X
      C Z
    STRING
    assert_equal 12, ElfRPS.new(io).process
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts ElfRPS.new(ARGF).process

end
