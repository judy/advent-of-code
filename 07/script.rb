#!/usr/bin/env ruby
require 'minitest'

# NOTE: This will fail if any folder names are the same. If that's the case,
# then folder_sizes will have to either be recursive, or include the full
# path name as the key.
def build_filesystem(io)
  folder_stack = []
  folder_sizes = Hash.new(0)

  io.each(chomp: true) do |line|
    case line.split(' ')
    in ['$', 'cd', '..']
      folder_stack.pop
    in ['$', 'cd', String => folder]
      folder = "root" if folder == '/'
      full_path = [folder_stack.last, folder].compact.join('/')
      folder_stack.push full_path
    in ['$', 'ls']
      # noop
    in ['dir', String => folder]
      # noop # may have to check for nonexistent folder later?
    in [String => size, String => _]
      folder_stack.each do |folder|
        folder_sizes[folder] += size.to_i
      end
    else
      raise "unknown line: #{line}"
    end
  end
  # puts folder_stack.inspect
  # puts folder_sizes.inspect
  folder_sizes
end

def sum_of_all_folders_below_100_000(fs)
  fs.select { |_,v| v < 100_000 }.values.sum
end

def smallest_folder_deletable_to_free_30_000_000(fs)
  smallest_folder_min = 70_000_000 - 30_000_000 # 40_000_000
  uneligible_folder_size = fs["root"] - smallest_folder_min
  eligible_folders = fs.reject { |_,v| v < uneligible_folder_size }
  eligible_folders.values.min
end

class Test < MiniTest::Test
  def test_build_filesystem
    io = StringIO.new <<~STRING
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
    STRING
    assert_equal 95437, sum_of_all_folders_below_100_000(build_filesystem(io))
  end

  def test_sum_of_all_folders_below_100_000
    fs = { "root" => 48381165, e: 584, a: 94853, d: 24933642 }
    assert_equal 95437, sum_of_all_folders_below_100_000(fs)
  end

  def test_smallest_folder_deletable_to_free_30_000_000
    fs = { "root" => 48381165, e: 584, a: 94853, d: 24933642 }
    assert_equal 24933642, smallest_folder_deletable_to_free_30_000_000(fs)
  end
end

if ARGV[0] == 'test'
  MiniTest.run
else
  fs = build_filesystem(ARGF)
  puts "Solution 1: #{sum_of_all_folders_below_100_000(fs)}"
  puts "Solution 2: #{smallest_folder_deletable_to_free_30_000_000(fs)}"
end
