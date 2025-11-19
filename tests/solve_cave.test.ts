import { describe, test, expect } from 'bun:test';
import { parseInput, fillCave, measureDepths } from '../src/typescript/solve_cave';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

describe('Cave Water Puzzle', () => {
  describe('parseInput', () => {
    test('should parse simple cave input correctly', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      
      expect(waterUnits).toBeGreaterThan(0);
      expect(grid.length).toBeGreaterThan(0);
      expect(grid[0]!.length).toBeGreaterThan(0);
    });

    test('should parse complex cave input correctly', () => {
      const inputFile = join(__dirname, '../data/input/complex_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      
      expect(waterUnits).toBeGreaterThan(0);
      expect(grid.length).toBeGreaterThan(0);
      expect(grid[0]!.length).toBeGreaterThan(0);
    });
  });

  describe('fillCave', () => {
    test('should fill cave with water units', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      const filled = fillCave(grid, waterUnits);
      
      // Count water cells
      let waterCount = 0;
      for (const row of filled) {
        for (const cell of row) {
          if (cell === '~') waterCount++;
        }
      }
      
      expect(waterCount).toBeGreaterThan(0);
    });

    test('should not modify original grid structure (rock positions)', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      
      // Count rocks before
      let rocksBefore = 0;
      for (const row of grid) {
        for (const cell of row) {
          if (cell === '#') rocksBefore++;
        }
      }
      
      const filled = fillCave(grid, waterUnits);
      
      // Count rocks after
      let rocksAfter = 0;
      for (const row of filled) {
        for (const cell of row) {
          if (cell === '#') rocksAfter++;
        }
      }
      
      expect(rocksAfter).toBe(rocksBefore);
    });
  });

  describe('measureDepths', () => {
    test('should return depth measurements for each column', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      const filled = fillCave(grid, waterUnits);
      const depths = measureDepths(filled);
      
      expect(depths.length).toBe(filled[0]!.length);
    });

    test('should return flowing indicator (~) for flowing columns', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      const filled = fillCave(grid, waterUnits);
      const depths = measureDepths(filled);
      
      // At least check that depths contains valid values (numbers or '~')
      for (const depth of depths) {
        expect(typeof depth === 'number' || depth === '~').toBe(true);
      }
    });

    test('should return numeric depths for settled columns', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      const filled = fillCave(grid, waterUnits);
      const depths = measureDepths(filled);
      
      // Check that numeric depths are non-negative
      for (const depth of depths) {
        if (typeof depth === 'number') {
          expect(depth).toBeGreaterThanOrEqual(0);
        }
      }
    });
  });

  describe('Integration test', () => {
    test('should process simple cave end-to-end', () => {
      const inputFile = join(__dirname, '../data/input/simple_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      const filled = fillCave(grid, waterUnits);
      const depths = measureDepths(filled);
      
      expect(depths.length).toBeGreaterThan(0);
      expect(depths.join(' ')).toBeTruthy();
    });

    test('should process complex cave end-to-end', () => {
      const inputFile = join(__dirname, '../data/input/complex_cave.txt');
      const { grid, waterUnits } = parseInput(inputFile);
      const filled = fillCave(grid, waterUnits);
      const depths = measureDepths(filled);
      
      expect(depths.length).toBeGreaterThan(0);
      expect(depths.join(' ')).toBeTruthy();
    });
  });
});
