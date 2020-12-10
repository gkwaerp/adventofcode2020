//
//  Day10VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 10/12/2020.
//

import UIKit

class Day10VC: AoCVC, AdventDay, InputLoadable {
    private var ratings: [Int] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.ratings = input.map({Int($0)!})
    }
    
    func solveFirst() {
        let result = self.part1(with: self.ratings)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(with: self.ratings)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(with adapters: [Int]) -> Int {
        let builtIn = adapters.max()! + 3
        let sorted = [0] + adapters.sorted() + [builtIn]
        var numDeltas: [Int : Int] = [:] // Rating delta --> Count
        for i in 1..<sorted.count {
            let adapter = sorted[i]
            let delta = adapter - sorted[i - 1]
            numDeltas[delta, default: 0] += 1
        }
        return numDeltas[1]! * numDeltas[3]!
    }
        
    private func part2(with adapters: [Int]) -> Int {
        let builtIn = adapters.max()! + 3
        let sorted = [0] + adapters.sorted() + [builtIn]
        
        var requiredAdapterIndicesSet: Set<Int> = [0]
        for i in 1..<sorted.count - 1 {
            let prev = sorted[i - 1]
            let curr = sorted[i]
            let delta = curr - prev
            if delta == 3 {
                requiredAdapterIndicesSet.insert(i)
                requiredAdapterIndicesSet.insert(i - 1)
            }
        }
        
        let requiredAdapterIndices = requiredAdapterIndicesSet.sorted()
        var splitOnRequired: [[Int]] = []
        for i in 0..<requiredAdapterIndices.count - 1 {
            let startIndex = requiredAdapterIndices[i]
            let endIndex = requiredAdapterIndices[i + 1]
            splitOnRequired.append(Array(sorted[startIndex...endIndex]))
        }
        splitOnRequired.append(Array(sorted[requiredAdapterIndices.last!...]))
        let filtered = splitOnRequired.filter({$0.count > 2})

        var validCombinations = 1
        for group in filtered {
            let endIndex = group.count - 1
            let trimmed = Array(group[1..<endIndex])
            let combinations = PermutationHelper.allCombinations(trimmed)
                .filter({self.isValid(adapters: [group.first!] + $0 + [group.last!])})
            validCombinations *= combinations.count
        }
        
        return validCombinations
    }
    
    private func isValid(adapters: [Int]) -> Bool {
        guard !adapters.isEmpty else { return false }
        for i in 0..<adapters.count - 1 {
            if adapters[i + 1] - adapters[i] > 3 {
                return false
            }
        }
        
        return true
    }
    
    private func part2_alt(with adapters: [Int]) -> Int {
        let builtIn = adapters.max()! + 3
        let sorted = [0] + adapters.sorted() + [builtIn]
        var combinationCounts: [Int] = [1]
        for i in 1..<sorted.count {
            var count = 0
            for lookbackOffset in 1...3 {
                let lookbackIndex = i - lookbackOffset
                if lookbackIndex >= 0 {
                    let delta = sorted[i] - sorted[lookbackIndex]
                    count += (delta > 3) ? 0 : combinationCounts[lookbackIndex]
                }
            }
            combinationCounts.append(count)
        }
        return combinationCounts.last!
    }
}

extension Day10VC: TestableDay {
    func runTests() {
        let testInput =
        """
        16
        10
        15
        5
        1
        11
        7
        19
        6
        12
        4
        """.components(separatedBy: "\n")
        let ratings = testInput.map({Int($0)!})
        
        let p1 = self.part1(with: ratings)
        let p2 = self.part2(with: ratings)
        
        assert(p1 == 35)
        assert(p2 == 8)
        assert(self.part2(with: ratings) == self.part2_alt(with: ratings))
        
        let testInput2 =
        """
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
        """.components(separatedBy: "\n")
        let ratings2 = testInput2.map({Int($0)!})
        let p1_2 = self.part1(with: ratings2)
        let p2_2 = self.part2(with: ratings2)
        assert(p1_2 == 220)
        assert(p2_2 == 19208)
        assert(self.part2(with: ratings2) == self.part2_alt(with: ratings2))
    }
}
