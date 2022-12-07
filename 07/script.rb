#!/usr/bin/env ruby
require 'minitest'

class Test < MiniTest::Test

end

if ARGV[0] == 'test'
  MiniTest.run
else
  raise "unused"
end
