#!/usr/bin/env ruby
require 'minitest'

class Device
  def initialize(datastream)
    @datastream = datastream # must be IO object
  end

  def find_start_of_packet_marker
    position = 0
    possible_marker = []
    while char = @datastream.gets(1)
      position += 1
      possible_marker.shift(1) if possible_marker.length == 4
      possible_marker << char
      break if possible_marker.uniq.length == 4
    end
    position
  end
end

class DeviceTest < MiniTest::Test
  def test_find_start_of_packet_marker
    assert_equal 7, Device.new(StringIO.new("mjqjpqmgbljsphdztnvjfqwrcgsmlb")).find_start_of_packet_marker
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  puts Device.new(ARGF).find_start_of_packet_marker
end
