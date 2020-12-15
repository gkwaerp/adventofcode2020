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
        var histories: [Int : [Int]] = [:] // Number --> When spoken
        
        var last = -1
        for turn in 1...numTurns {
            let number: Int
            if numbers.count > turn - 1 {
                number = numbers[turn - 1]
            } else {
                if histories[last, default: []].count > 1 {
                    let history = histories[last]!
                    let prevTurn = history.last!
                    let priorTurn = history[history.count - 2]
                    number = prevTurn - priorTurn
                } else {
                    number = 0
                }
            }
            histories[number, default: []].append(turn)
            last = number
        }
        
        return last
    }
}


extension Day15VC: TestableDay {
    func runTests() {
        let p1 = self.countingGame(numbers: [0,3,6], numTurns: 2020)
        let p2 = self.countingGame(numbers: [0,3,6], numTurns: 30000000)
        
        assert(p1 == 436)
        assert(p2 == 175594)
    }
}
