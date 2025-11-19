import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

interface ParsedInput {
  grid: string[][];
  waterUnits: number;
}

function parseInput(filename: string): ParsedInput {
  const content = readFileSync(filename, 'utf-8');
  const lines = content.split('\n');
  const waterUnits = parseInt(lines[0]?.trim() || '0');
  const caveLines = lines.slice(2).filter(line => line.length > 0);
  const grid = caveLines.map(line => line.split(''));
  return { grid, waterUnits };
}

function fillCave(grid: string[][], waterUnits: number): string[][] {
  // The input file already has one water unit placed, so we add (waterUnits - 1) more
  for (let i = 0; i < waterUnits - 1; i++) {
    addWater(grid);
  }
  return grid;
}

function addWater(grid: string[][]): void {
  const height = grid.length;
  const width = grid[0]?.length || 0;
  const queue: [number, number][] = [];
  
  // Find all current water cells
  for (let i = 0; i < height; i++) {
    for (let j = 0; j < width; j++) {
      if (grid[i]?.[j] === '~') {
        queue.push([i, j]);
      }
    }
  }
  
  // If no water yet, start at inlet (top left open cell)
  if (queue.length === 0) {
    for (let j = 0; j < width; j++) {
      if (grid[0]?.[j] === ' ') {
        grid[0]![j] = '~';
        return;
      }
    }
    return;
  }
  
  // Try to expand water from each cell in queue (BFS order)
  while (queue.length > 0) {
    const [i, j] = queue.shift()!;
    
    // Flow down
    if (i + 1 < height && grid[i + 1]?.[j] === ' ') {
      grid[i + 1]![j] = '~';
      return;
    }
    
    // Spread right
    if (j + 1 < width && grid[i]?.[j + 1] === ' ') {
      grid[i]![j + 1] = '~';
      return;
    }
    
    // Spread left
    if (j - 1 >= 0 && grid[i]?.[j - 1] === ' ') {
      grid[i]![j - 1] = '~';
      return;
    }
    
    // Spread up (rare, for trapped air)
    if (i - 1 >= 0 && grid[i - 1]?.[j] === ' ') {
      grid[i - 1]![j] = '~';
      return;
    }
  }
}

function measureDepths(grid: string[][]): (number | string)[] {
  const height = grid.length;
  const width = grid[0]?.length || 0;
  const depths: (number | string)[] = [];
  
  for (let c = 0; c < width; c++) {
    // Check if water is flowing in this column (has '~' with space below)
    let flowing = false;
    for (let r = 0; r < height - 1; r++) {
      if (grid[r]?.[c] === '~' && grid[r + 1]?.[c] === ' ') {
        flowing = true;
        break;
      }
    }
    
    if (flowing) {
      depths.push('~');
    } else {
      // Count all '~' symbols in the column
      let depth = 0;
      for (let r = 0; r < height; r++) {
        if (grid[r]?.[c] === '~') {
          depth++;
        }
      }
      depths.push(depth);
    }
  }
  
  return depths;
}

function main() {
  const args = process.argv.slice(2);
  const __dirname = dirname(fileURLToPath(import.meta.url));
  const defaultInput = join(__dirname, '../../data/input/simple_cave.txt');
  const inputFile = args[0] || defaultInput;
  
  const { grid, waterUnits } = parseInput(inputFile);
  const filled = fillCave(grid, waterUnits);
  const depths = measureDepths(filled);
  
  console.log(depths.join(' '));
}

if (require.main === module) {
  main();
}

export { parseInput, fillCave, measureDepths };
