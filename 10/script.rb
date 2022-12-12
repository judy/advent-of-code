#!/usr/bin/env ruby
require 'minitest'
require 'minitest/focus'
require 'tty-cursor'
require 'pry'

class Device
  attr_reader :x, :signal_strengths
  def initialize(io)
    @io = io
    @x = 1
    @cycle_counter = 0
    @active_instruction = nil
    @signal_strengths = Hash[[20, 60, 100, 140, 180, 220].map { |n| [n, nil] }]
    @cursor = TTY::Cursor
  end

  def run
    print @cursor.clear_screen
    print "\n\n "
    while true
      @cycle_counter += 1
      check_signal_strengths
      draw_crt
      if @active_instruction
        send(*@active_instruction.split)
      else
        line = @io.readline.chomp.strip
        next if line == 'noop'

        @active_instruction = line
      end
    end
  rescue EOFError
    puts "\n\n"

    self
  end

  def addx(n)
    @x += n.to_i
    @active_instruction = nil
  end

  def check_signal_strengths
    if @signal_strengths.include?(@cycle_counter)
      @signal_strengths[@cycle_counter] = @x
    end
  end

  def draw_crt
    if hpos >= @x && hpos <= @x + 2
      print '#'
    else
      print '.'
    end

    draw_sprite_checker

    sleep 0.05

    print "\n " if @cycle_counter % 40 == 0
  end

  def draw_sprite_checker
    print @cursor.save
    print @cursor.next_line
    print @cursor.clear_line
    print @cursor.forward(@x)
    print 'XXX'
    print @cursor.restore
  end

  def hpos
    @cycle_counter % 40
  end

  def magical_output
    @signal_strengths.inject(0) do |sum, (k, v)|
      sum += k * v.to_i
    end
  end
end

class Test < MiniTest::Test
  def test_tiny_example
    skip
    io = StringIO.new <<~STRING
      noop
      addx 3
      addx -5
    STRING
    device = Device.new(io).run
    assert_equal -1, device.x
  end

  def test_example
    file = File.open(__dir__ + '/small_program.txt')
    device = Device.new(file).run
    assert_equal 13140, device.magical_output
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts Device.new(ARGF).run.magical_output
end
