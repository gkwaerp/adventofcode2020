//
//  Day03VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 03/12/2020.
//

import UIKit

class Day03VC: AoCVC, AdventDay, InputLoadable {
    private var grid: Grid!
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        var values: [Grid.GridValue] = []
        for line in input {
            for char in line {
                values.append(String(char))
            }
        }
        let size = IntPoint(x: input.first!.count, y: input.count)
        self.grid = Grid(size: size, values: values)
    }
    
    private let p1Movement = IntPoint(x: 3, y: 1)
    private let p2Movements: [IntPoint] = [IntPoint(x: 1, y: 1),
                                           IntPoint(x: 3, y: 1),
                                           IntPoint(x: 5, y: 1),
                                           IntPoint(x: 7, y: 1),
                                           IntPoint(x: 1, y: 2)]
    
    func solveFirst() {
        let numTrees = self.countTrees(in: self.grid, with: self.p1Movement)
        self.setSolution(challenge: 0, text: "\(numTrees)")
    }
    
    func solveSecond() {
        let numTrees = self.p2Movements.map({self.countTrees(in: self.grid, with: $0)}).reduce(1, *)
        self.setSolution(challenge: 1, text: "\(numTrees)")
    }
    
    private func countTrees(in grid: Grid, with movement: IntPoint) -> Int {
        let startPos = IntPoint.origin
        var currPos = startPos.copy()
        var numTrees = 0
        while let gridValue = grid.getValue(at: currPos) {
            if gridValue == "#" {
                numTrees += 1
            }
            currPos += movement
            currPos.x %= grid.width
        }
        
        return numTrees
    }
}

extension Day03VC: TestableDay {
    func runTests() {
        let testInput =
        """
        ..##.......
        #...#...#..
        .#....#..#.
        ..#.#...#.#
        .#...##..#.
        ..#.##.....
        .#.#.#....#
        .#........#
        #.##...#...
        #...##....#
        .#..#...#.#
        """.components(separatedBy: "\n")
        var values: [Grid.GridValue] = []
        for line in testInput {
            for char in line {
                values.append(String(char))
            }
        }
        let grid = Grid(size: IntPoint(x: testInput.first!.count, y: testInput.count), values: values)
        let numTrees1 = self.countTrees(in: grid, with: self.p1Movement)
        let numTrees2 = self.p2Movements.map({self.countTrees(in: grid, with: $0)}).reduce(1, *)
        assert(numTrees1 == 7)
        assert(numTrees2 == 336)
    }
}
