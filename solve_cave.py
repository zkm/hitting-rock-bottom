from collections import deque

def parse_input(filename):
    with open(filename) as f:
        lines = f.read().splitlines()
    water_units = int(lines[0].strip())
    cave_lines = [line for line in lines[2:] if line.strip()]
    grid = [list(line) for line in cave_lines]
    return grid, water_units

def fill_cave(grid, water_units):
    height, width = len(grid), len(grid[0])
    inlet_col = next((i for i, c in enumerate(grid[0]) if c == '~' or c == ' '), 1)
    # Place initial water unit at inlet
    r = 0
    while r + 1 < height and grid[r + 1][inlet_col] == ' ':
        r += 1
    grid[r][inlet_col] = '~'
    water_units -= 1
    def next_to_water(i, j):
        return j > 0 and grid[i][j - 1] == '~'
    def underneath_water(i, j):
        return i > 0 and grid[i - 1][j] == '~'
    for _ in range(water_units):
        placed = False
        for i in range(height - 1, -1, -1):
            for j in range(width - 1, -1, -1):
                if grid[i][j] == ' ':
                    if underneath_water(i, j) or next_to_water(i, j):
                        grid[i][j] = '~'
                        placed = True
                        break
            if placed:
                break
    return grid

def measure_depths(grid):
    height, width = len(grid), len(grid[0])
    depths = []
    for c in range(width):
        depth = 0
        flowing = False
        for r in range(height):
            if grid[r][c] == '~':
                depth += 1
                if r+1 < height and grid[r+1][c] == ' ':
                    flowing = True
                    break
            elif grid[r][c] == '#':
                break
        depths.append('~' if flowing else depth)
    return depths

def main():
    import sys
    input_file = sys.argv[1] if len(sys.argv) > 1 else 'simple_cave.txt'
    grid, water_units = parse_input(input_file)
    filled = fill_cave(grid, water_units)
    depths = measure_depths(filled)
    print(' '.join(str(d) for d in depths))

if __name__ == '__main__':
    main()
