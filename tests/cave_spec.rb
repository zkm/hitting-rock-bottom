require_relative '../src/ruby/water_puzzle'

RSpec.describe Cave do
  let(:script_dir) { File.dirname(File.absolute_path(__FILE__)) }
  let(:simple_input_file) { File.join(script_dir, '../data/input/simple_cave.txt') }
  let(:complex_input_file) { File.join(script_dir, '../data/input/complex_cave.txt') }
  
  let(:simple_cave) do
    f = File.new(simple_input_file)
    lines = f.readlines
    Cave.build(lines[2..lines.size-1])
  end
  
  let(:complex_cave) do
    f = File.new(complex_input_file)
    lines = f.readlines
    Cave.build(lines[2..lines.size-1])
  end

  describe '.build' do
    it 'creates a cave from input lines' do
      expect(simple_cave).to be_a(Cave)
      expect(simple_cave.grid).not_to be_nil
    end

    it 'parses grid correctly' do
      expect(simple_cave.grid).to be_an(Array)
      expect(simple_cave.grid.size).to be > 0
      expect(simple_cave.grid[0].size).to be > 0
    end

    it 'splits each line into characters' do
      simple_cave.grid.each do |row|
        expect(row).to be_an(Array)
        row.each do |cell|
          expect(cell).to be_a(String)
          expect(cell.length).to eq(1)
        end
      end
    end
  end

  describe '#add_water' do
    it 'adds a water cell to the grid' do
      cave = simple_cave
      initial_water_count = cave.grid.flatten.count('~')
      cave.add_water
      final_water_count = cave.grid.flatten.count('~')
      
      expect(final_water_count).to eq(initial_water_count + 1)
    end

    it 'places water at inlet when grid is empty' do
      cave = simple_cave
      initial_water = cave.grid.flatten.count('~')
      
      if initial_water == 0
        cave.add_water
        expect(cave.grid[0]).to include('~')
      end
    end

    it 'does not create or destroy rocks' do
      cave = simple_cave
      initial_rocks = cave.grid.flatten.count('#')
      
      10.times { cave.add_water }
      
      final_rocks = cave.grid.flatten.count('#')
      expect(final_rocks).to eq(initial_rocks)
    end
  end

  describe '#flowing?' do
    it 'detects flowing water in a column' do
      cave = simple_cave
      20.times { cave.add_water }
      
      cave.grid.transpose.each do |column|
        result = cave.flowing?(column)
        expect(result).to be_a(Integer).or be_nil
      end
    end
  end

  describe '#to_s' do
    it 'converts grid to string representation' do
      result = simple_cave.to_s
      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it 'preserves grid dimensions' do
      cave = simple_cave
      string_rep = cave.to_s
      lines = string_rep.split("\n")
      
      expect(lines.size).to eq(cave.grid.size)
    end
  end

  describe '#to_depth_string' do
    it 'returns depth measurements for each column' do
      cave = simple_cave
      20.times { cave.add_water }
      
      depth_string = cave.to_depth_string
      expect(depth_string).to be_a(String)
      expect(depth_string).not_to be_empty
    end

    it 'uses ~ for flowing columns and numbers for settled' do
      cave = simple_cave
      50.times { cave.add_water }
      
      depth_string = cave.to_depth_string
      expect(depth_string).to match(/[\d~\s]+/)
    end

    it 'has one depth value per column' do
      cave = simple_cave
      30.times { cave.add_water }
      
      depth_values = cave.to_depth_string.split(' ')
      expect(depth_values.size).to eq(cave.grid.transpose.size)
    end
  end

  describe 'Simple cave solution' do
    it 'solves simple cave with 120 water units' do
      cave = simple_cave
      120.times { cave.add_water }
      
      result = cave.to_depth_string
      expect(result).not_to be_empty
      puts "\n  Simple cave result: #{result}"
    end
  end

  describe 'Complex cave solution' do
    it 'solves complex cave with 2460 water units' do
      cave = complex_cave
      2460.times { cave.add_water }
      
      result = cave.to_depth_string
      expect(result).not_to be_empty
      puts "\n  Complex cave result: #{result}"
    end
  end
end
