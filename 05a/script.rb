#!/usr/bin/env ruby
require 'minitest'

class ShipTest < MiniTest::Test

end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise 'no input handler yet'
end
