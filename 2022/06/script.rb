#!/usr/bin/env ruby
require 'minitest'

class Device
  PACKET_LENGTH = 14
  def initialize(datastream)
    @datastream = datastream # must be IO object
  end

  def find_start_of_message_marker
    position = 0
    possible_marker = []
    while char = @datastream.gets(1)
      position += 1
      possible_marker.shift(1) if possible_marker.length == PACKET_LENGTH
      possible_marker << char
      break if possible_marker.uniq.length == PACKET_LENGTH
    end
    position
  end
end

class DeviceTest < MiniTest::Test
  def test_find_start_of_message_marker
    assert_equal 19, Device.new(StringIO.new("mjqjpqmgbljsphdztnvjfqwrcgsmlb")).find_start_of_message_marker
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts Device.new(ARGF).find_start_of_message_marker
end
