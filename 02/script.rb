#!/usr/bin/env ruby
require 'minitest'

class ElfRPS
  def initialize(io)
    @io = io
    @score = 0
  end

  def process
    @io.each_line do |line|
      elf, me = line.split(" ")
      case me
      when "X" # rock
        @score += 1
        case elf
        when "A" # rock
          @score += 3
        when "B" # paper
          @score += 0
        when "C" # scissors
          @score += 6
        end
      when "Y" # paper
        @score += 2
        case elf
        when "A" # rock
          @score += 6
        when "B" # paper
          @score += 3
        when "C" # scissors
          @score += 0
        end
      when "Z" # scissors
        @score += 3
        case elf
        when "A" # rock
          @score += 0
        when "B" # paper
          @score += 6
        when "C" # scissors
          @score += 3
        end
      end
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
    assert_equal 15, ElfRPS.new(io).process
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts ElfRPS.new(ARGF).process

end
