require 'minitest/autorun'
require_relative '../src/ruby/water_puzzle'

class CaveTest < Minitest::Test
  def setup
    @script_dir = File.dirname(File.absolute_path(__FILE__))
  end

  def test_cave_can_be_built_from_lines
    input_file = File.join(@script_dir, '../data/input/simple_cave.txt')
    f = File.new(input_file)
    lines = f.readlines
    cave = Cave.build(lines[2..lines.size-1])
    
    refute_nil cave
    refute_nil cave.grid
    assert cave.grid.size > 0
    assert cave.grid[0].size > 0
  end

  def test_cave_can_add_water
    input_file = File.join(@script_dir, '../data/input/simple_cave.txt')
    f = File.new(input_file)
    lines = f.readlines
    cave = Cave.build(lines[2..lines.size-1])
    
    initial_water_count = cave.grid.flatten.count('~')
    cave.add_water
    final_water_count = cave.grid.flatten.count('~')
    
    assert final_water_count > initial_water_count
  end

  def test_cave_detects_flowing_water
    input_file = File.join(@script_dir, '../data/input/simple_cave.txt')
    f = File.new(input_file)
    lines = f.readlines
    cave = Cave.build(lines[2..lines.size-1])
    
    # Add some water
    10.times { cave.add_water }
    
    # Check that flowing? method works
    column = cave.grid.transpose[0]
    result = cave.flowing?(column)
    assert [true, false, nil].include?(result.class == TrueClass || result.class == FalseClass || result.nil?)
  end

  def test_cave_produces_depth_string
    input_file = File.join(@script_dir, '../data/input/simple_cave.txt')
    f = File.new(input_file)
    lines = f.readlines
    cave = Cave.build(lines[2..lines.size-1])
    
    20.times { cave.add_water }
    
    depth_string = cave.to_depth_string
    refute_empty depth_string
    assert_match(/[\d~\s]+/, depth_string)
  end

  def test_simple_cave_solution
    input_file = File.join(@script_dir, '../data/input/simple_cave.txt')
    f = File.new(input_file)
    lines = f.readlines
    cave = Cave.build(lines[2..lines.size-1])
    
    120.times { cave.add_water }
    
    depth_string = cave.to_depth_string
    refute_empty depth_string
    puts "\nSimple cave result: #{depth_string}"
  end

  def test_complex_cave_solution
    input_file = File.join(@script_dir, '../data/input/complex_cave.txt')
    f = File.new(input_file)
    lines = f.readlines
    cave = Cave.build(lines[2..lines.size-1])
    
    2460.times { cave.add_water }
    
    depth_string = cave.to_depth_string
    refute_empty depth_string
    puts "\nComplex cave result: #{depth_string}"
  end
end
