//
//  Day15VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 15/12/2020.
//

import UIKit

class Day15VC: AoCVC, AdventDay {
    private let input: [Int] = [0,1,5,10,3,12,19]
    
    func solveFirst() {
        let result = self.countingGame(numbers: self.input, numTurns: 2020)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.countingGame(numbers: self.input, numTurns: 30000000)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func countingGame(numbers: [Int], numTurns: Int) -> Int {
        var history: [Int : Int] = [:] // Number --> Last spoken
        
        for (turn, number) in numbers.enumerated() {
            history[number] = turn
        }
        
        var lastSpoken = numbers.last!
        for turn in numbers.count..<numTurns {
            let candidate = (turn - history[lastSpoken, default: turn] - 1)
            let number = candidate > 0 ? candidate : 0
            history[lastSpoken] = turn - 1
            lastSpoken = number
        }
        
        return lastSpoken
    }
}


extension Day15VC: TestableDay {
    func runTests() {
        let p1 = self.countingGame(numbers: [0,3,6], numTurns: 2020)
        assert(p1 == 436)
        
        let p2 = self.countingGame(numbers: [0,3,6], numTurns: 30000000)
        assert(p2 == 175594)
    }
}
