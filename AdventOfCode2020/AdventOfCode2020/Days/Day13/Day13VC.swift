//
//  Day13VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 13/12/2020.
//

import UIKit

class Day13VC: AoCVC, AdventDay, InputLoadable {
    private struct Something {
        static func from(_ string: String) -> Something {
            return Something()
        }
    }
    
    private var timestamp: Int = 0
    private var busIDs: [Int] = []
    private var rawBusIds: [String] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.timestamp = Int(input[0])!
        self.rawBusIds = input[1].components(separatedBy: ",")
        self.busIDs = self.rawBusIds.compactMap({Int($0)})
    }
    
    func solveFirst() {
        let result = self.part1(self.timestamp, self.busIDs)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(self.rawBusIds)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(_ timestamp: Int, _ busIDs: [Int]) -> Int {
        var bestDelay = Int.max
        var bestID = -1
        
        for id in busIDs {
            let delay = id - (timestamp % id)
            if delay < bestDelay {
                bestDelay = delay
                bestID = id
            }
        }
        
        return bestDelay * bestID
    }
    
    private func part2(_ rawBusIds: [String]) -> Int {
        var timestamp = 0
        var numSkips = 1
        
        for i in 0..<rawBusIds.count {
            guard let id = Int(rawBusIds[i]) else { continue }
            while (timestamp + i) % id != 0 {
                timestamp += numSkips
            }
            numSkips *= id
        }
        
        return timestamp
    }
}

extension Day13VC: TestableDay {
    func runTests() {
        let p1Timestamp = 939
        let p1BusIds = "7,13,x,x,59,x,31,19".components(separatedBy: ",").compactMap({Int($0)})
        assert(self.part1(p1Timestamp, p1BusIds) == 295)
        
        assert(self.part2("7,13,x,x,59,x,31,19".components(separatedBy: ",")) == 1068781)
        assert(self.part2("67,7,59,61".components(separatedBy: ",")) == 754018)
        assert(self.part2("67,x,7,59,61".components(separatedBy: ",")) == 779210)
        assert(self.part2("67,7,x,59,61".components(separatedBy: ",")) == 1261476)
        assert(self.part2("1789,37,47,1889".components(separatedBy: ",")) == 1202161486)
    }
}
