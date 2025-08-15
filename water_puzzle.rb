class Cave
  attr_accessor :grid

  def self.build(lines)
    cave = Cave.new
    cave.grid = lines.tap do |lines|
      lines.collect! { |line| line.strip.split('') }
    end
    cave
  end

  def add_water
    # BFS approach: find all edge water cells, expand from there
    height = grid.size
    width = grid[0].size
    queue = []
    visited = Array.new(height) { Array.new(width, false) }
    # Find all current water cells
    height.times do |i|
      width.times do |j|
        if grid[i][j] == '~'
          queue << [i, j]
          visited[i][j] = true
        end
      end
    end
    # If no water yet, start at inlet (top left open cell)
    if queue.empty?
      inlet_j = grid[0].find_index(' ')
      queue << [0, inlet_j]
      grid[0][inlet_j] = '~'
      visited[0][inlet_j] = true
      return
    end
    # Try to expand water from each edge cell
    while !queue.empty?
      i, j = queue.shift
      # Flow down
      if i + 1 < height && grid[i + 1][j] == ' '
        grid[i + 1][j] = '~'
        return
      end
      # Spread right
      if j + 1 < width && grid[i][j + 1] == ' '
        grid[i][j + 1] = '~'
        return
      end
      # Spread left
      if j - 1 >= 0 && grid[i][j - 1] == ' '
        grid[i][j - 1] = '~'
        return
      end
      # Spread up (rare, for trapped air)
      if i - 1 >= 0 && grid[i - 1][j] == ' '
        grid[i - 1][j] = '~'
        return
      end
    end
  end

  def flowing?(column)
    column.to_a.join.index('~ ')
  end

  def to_s
    grid.collect { |row| row.to_a.join }.join("\n")
  end

  def to_depth_string
    grid.transpose.collect do |column|
      if flowing?(column)
        '~'
      else
        "#{column.count('~')}"
      end
    end.join(' ')
  end
  private
  def next_to_water?(i, j)
    grid[i][j - 1] == '~'
  end
  def underneath_water?(i, j)
    grid[i - 1][j] == '~'
  end
end

f = File.new('complex_cave.txt')
lines = f.readlines
cave = Cave.build(lines[2..lines.size-1])
2460.times do
  cave.add_water
end

#puts cave.to_s
puts cave.to_depth_string
