//
//  Day09VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 09/12/2020.
//

import UIKit

class Day09VC: AoCVC, AdventDay, InputLoadable {
    private var numbers: [Int] = []
    
    func loadInput() {
        self.numbers = self.defaultInputFileString.loadAsTextStringArray().map({Int($0)!})
    }
    
    func solveFirst() {
        let result = self.findFirstNonMatching(in: self.numbers, preamble: 25)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.findContiguousSumResult(in: self.numbers, preamble: 25)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func findFirstNonMatching(in numbers: [Int], preamble: Int) -> Int {
        var window = numbers.prefix(preamble)
        for candidate in numbers[preamble...] {
            var found = false
            for num in window {
                if window.contains(candidate - num) {
                    found = true
                    window.remove(at: 0)
                    window.append(candidate)
                    break
                }
            }
            if !found {
                return candidate
            }
        }
        fatalError("No non-matching numbers found")
    }
    
    private func findContiguousSumResult(in numbers: [Int], preamble: Int) -> Int {
        let target = self.findFirstNonMatching(in: numbers, preamble: preamble)
        var startIndex = 0
        var endIndex = 0
        var currSum = numbers[startIndex]
        while startIndex < numbers.count {
            if currSum == target {
                let finalSegment = numbers[startIndex...endIndex]
                return finalSegment.min()! + finalSegment.max()!
            } else if currSum < target {
                endIndex += 1
                currSum += numbers[endIndex]
            } else {
                currSum -= numbers[startIndex]
                startIndex += 1
            }
        }
        
        fatalError("No contiguous numbers sum to target.")
    }
}

extension Day09VC: TestableDay {
    func runTests() {
        let testInput =
        """
        35
        20
        15
        25
        47
        40
        62
        55
        65
        95
        102
        117
        150
        182
        127
        219
        299
        277
        309
        576
        """.components(separatedBy: "\n").map({Int($0)!})
        let preamble = 5
        assert(self.findFirstNonMatching(in: testInput, preamble: preamble) == 127)
        assert(self.findContiguousSumResult(in: testInput, preamble: preamble) == 62)
    }
}
