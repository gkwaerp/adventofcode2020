//
//  Day11VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 11/12/2020.
//

import UIKit

class Day11VC: AoCVC, AdventDay, InputLoadable {
    private var grid: Grid!
    
    func loadInput() {
        self.grid  = self.defaultInputFileString.loadAsGrid()
    }
    
    func solveFirst() {
        let result = self.part1(with: self.grid)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(with: self.grid)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(with grid: Grid) -> Int {
        let currGrid = Grid(size: grid.size, values: grid.values)
        while true {
            let nextGrid = Grid(size: currGrid.size, values: currGrid.values)
            let directions = IntPoint.allDirectionOffsets
            for y in 0..<currGrid.height {
                for x in 0..<currGrid.width {
                    let pos = IntPoint(x: x, y: y)
                    let numAdjacentSeats = directions.map { (direction) -> Int in
                        let newPos = pos + direction
                        let value = currGrid.getValue(at: newPos)
                        return value == "#" ? 1 : 0
                    }.reduce(0, +)
                    let currValue = currGrid.getValue(at: pos)
                    if currValue == "#" {
                        if numAdjacentSeats >= 4 {
                            nextGrid.setValue(at: pos, to: "L")
                        }
                    } else if currValue == "L" {
                        if numAdjacentSeats == 0 {
                            nextGrid.setValue(at: pos, to: "#")
                        }
                    }
                }
            }

            if currGrid.values == nextGrid.values {
                break
            }
            currGrid.values = nextGrid.values
        }
        
        return currGrid.values.filter({$0 == "#"}).count
    }
    
    private func part2(with grid: Grid) -> Int {
        let currGrid = Grid(size: grid.size, values: grid.values)
        while true {
            let nextGrid = Grid(size: currGrid.size, values: currGrid.values)
            let directions = IntPoint.allDirectionOffsets
            for y in 0..<currGrid.height {
                for x in 0..<currGrid.width {
                    let pos = IntPoint(x: x, y: y)
                    let numAdjacentSeats = directions.map { (direction) -> Int in
                        var newPos = pos
                        while true {
                            newPos += direction
                            guard let value = currGrid.getValue(at: newPos) else { return 0 }
                            if value == "#" {
                                return 1
                            } else if value == "L" {
                                return 0
                            }
                        }
                    }.reduce(0, +)
                    let currValue = currGrid.getValue(at: pos)
                    if currValue == "#" {
                        if numAdjacentSeats >= 5 {
                            nextGrid.setValue(at: pos, to: "L")
                        }
                    } else if currValue == "L" {
                        if numAdjacentSeats == 0 {
                            nextGrid.setValue(at: pos, to: "#")
                        }
                    }
                }
            }

            if currGrid.values == nextGrid.values {
                break
            }
            currGrid.values = nextGrid.values
        }
        
        return currGrid.values.filter({$0 == "#"}).count
    }
}

extension Day11VC: TestableDay {
    func runTests() {
        let testInput =
        """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """.components(separatedBy: "\n")
        let grid = Grid(stringArray: testInput)
        let p1 = self.part1(with: grid)
        let p2 = self.part2(with: grid)
        
        assert(p1 == 37)
        assert(p2 == 26)
    }
}
