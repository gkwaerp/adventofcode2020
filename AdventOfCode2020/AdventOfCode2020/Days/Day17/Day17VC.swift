//
//  Day17VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 17/12/2020.
//

import UIKit

class Day17VC: AoCVC, AdventDay, InputLoadable {
    private typealias ConwayMap = [String : Grid.GridValue]
    
    private class ConwayHyperCube {
        var points: ConwayMap
        private var extents: [IntPoint]
        
        init(_ grid: Grid) {
            self.extents = Array(repeating: .origin, count: 4)
            
            var points: ConwayMap = [:]
            for point in grid.gridPoints {
                let id = "\(point.x)-\(point.y)-\(0)-\(0)"
                points[id] = grid.getValue(at: point)
                self.extents[0].x = min(self.extents[0].x, point.x)
                self.extents[0].y = max(self.extents[0].x, point.x)
                self.extents[1].x = min(self.extents[1].x, point.y)
                self.extents[1].y = max(self.extents[1].x, point.y)
            }
            
            self.points = points
        }
        
        func tick() {
            var nextPoints: ConwayMap = [:]
            for w in (self.extents[3].x - 1)...(self.extents[3].y + 1) {
                for z in (self.extents[2].x - 1)...(self.extents[2].y + 1) {
                    for y in (self.extents[1].x - 1)...(self.extents[1].y + 1) {
                        for x in (self.extents[0].x - 1)...(self.extents[0].y + 1) {
                            let pos = "\(x)-\(y)-\(z)-\(w)"
                            
                            var activeNearby = 0
                            for offsetW in -1...1 {
                                for offsetZ in -1...1 {
                                    for offsetY in -1...1 {
                                        for offsetX in -1...1 {
                                            if offsetW == 0 && offsetZ == 0 && offsetY == 0 && offsetX == 0 { continue }
                                            let nearbyPos = "\(x+offsetX)-\(y+offsetY)-\(z+offsetZ)-\(w+offsetW)"
                                            activeNearby += (self.points[nearbyPos] == "#") ? 1 : 0
                                        }
                                    }
                                }
                            }
                            
                            let value = self.points[pos] ?? "."
                            var newActive = false
                            if value == "#" {
                                newActive = (2...3).contains(activeNearby)
                            } else if value == "." {
                                newActive = (activeNearby == 3)
                            }
                            nextPoints[pos] = newActive ? "#" : "."
                        }
                    }
                }
            }
            
            self.points = nextPoints
            for i in 0..<self.extents.count {
                self.extents[i] += IntPoint(x: -1, y: 1)
            }
        }
        
        var numActive: Int {
            return self.points.values.filter({$0 == "#"}).count
        }
    }
    
    private class ConwayCube {
        var points: ConwayMap
        private var extents: [IntPoint]
        
        init(_ grid: Grid) {
            self.extents = Array(repeating: .origin, count: 3)
            
            var points: ConwayMap = [:]
            for point in grid.gridPoints {
                let id = "\(point.x)-\(point.y)-\(0)"
                points[id] = grid.getValue(at: point)
                self.extents[0].x = min(self.extents[0].x, point.x)
                self.extents[0].y = max(self.extents[0].x, point.x)
                self.extents[1].x = min(self.extents[1].x, point.y)
                self.extents[1].y = max(self.extents[1].x, point.y)
            }
            
            self.points = points
        }
        
        func tick() {
            var nextPoints: ConwayMap = [:]
            for z in (self.extents[2].x - 1)...(self.extents[2].y + 1) {
                for y in (self.extents[1].x - 1)...(self.extents[1].y + 1) {
                    for x in (self.extents[0].x - 1)...(self.extents[0].y + 1) {
                        let pos = "\(x)-\(y)-\(z)"
                        
                        var activeNearby = 0
                        for offsetZ in -1...1 {
                            for offsetY in -1...1 {
                                for offsetX in -1...1 {
                                    if offsetZ == 0 && offsetY == 0 && offsetX == 0 { continue }
                                    let nearbyPos = "\(x+offsetX)-\(y+offsetY)-\(z+offsetZ)"
                                    activeNearby += (self.points[nearbyPos] == "#") ? 1 : 0
                                }
                            }
                        }
                        
                        let value = self.points[pos] ?? "."
                        var newActive = false
                        if value == "#" {
                            newActive = (2...3).contains(activeNearby)
                        } else if value == "." {
                            newActive = (activeNearby == 3)
                        }
                        nextPoints[pos] = newActive ? "#" : "."
                    }
                }
            }
            
            self.points = nextPoints
            for i in 0..<self.extents.count {
                self.extents[i] += IntPoint(x: -1, y: 1)
            }
        }
        
        var numActive: Int {
            return self.points.values.filter({$0 == "#"}).count
        }
    }
    
    private var input: Grid!
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsGrid()
    }
    
    func solveFirst() {
        let cube = ConwayCube(self.input)
        let result = self.part1(cube)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let cube = ConwayHyperCube(self.input)
        let result = self.part2(cube)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(_ conwayCube: ConwayCube) -> Int {
        let numCycles = 6
        for _ in 0..<numCycles {
            conwayCube.tick()
        }
        return conwayCube.numActive
    }
    
    private func part2(_ conwayHyperCube: ConwayHyperCube) -> Int {
        let numCycles = 6
        for _ in 0..<numCycles {
            conwayHyperCube.tick()
        }
        return conwayHyperCube.numActive
    }
}

extension Day17VC: TestableDay {
    func runTests() {
        let testInput =
        """
        .#.
        ..#
        ###
        """.components(separatedBy: "\n")
        let grid = Grid(stringArray: testInput)
        let conwayCube = ConwayCube(grid)
        let p1 = self.part1(conwayCube)
        assert(p1 == 112)
        
        let conwayHyperCube = ConwayHyperCube(grid)
        let p2 = self.part2(conwayHyperCube)
        assert(p2 == 848)
    }
}
