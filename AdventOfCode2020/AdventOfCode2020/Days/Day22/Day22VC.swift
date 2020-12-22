//
//  Day22VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 22/12/2020.
//

import UIKit

class Day22VC: AoCVC, AdventDay, InputLoadable {
    private var playerCards: [Int] = []
    private var crabCards: [Int] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray(separator: "\n\n")
        let parsed = self.parse(input)
        self.playerCards = parsed.playerCards
        self.crabCards = parsed.crabCards
    }
    
    private struct ParseResult {
        let playerCards: [Int]
        let crabCards: [Int]
    }
    private func parse(_ input: [String]) -> ParseResult {
        let playerCards: [Int] = input[0].components(separatedBy: "\n")[1...].map({Int($0)!})
        let crabCards: [Int] = input[1].components(separatedBy: "\n")[1...].map({Int($0)!})
        
        return ParseResult(playerCards: playerCards, crabCards: crabCards)
    }
    
    func solveFirst() {
        let result = self.part1(playerCards: self.playerCards, crabCards: self.crabCards)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(playerCards: self.playerCards, crabCards: self.crabCards)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(playerCards: [Int], crabCards: [Int]) -> Int {
        let winningDeck = self.playGame(player1: playerCards, player2: crabCards)
        let winningSum = winningDeck.reversed().enumerated().map({($0 + 1) * $1}).reduce(0, +)
        
        return winningSum
    }
    
    private func part2(playerCards: [Int], crabCards: [Int]) -> Int {
        let gameResult = self.playRecursiveGame(player1: playerCards, player2: crabCards)
        let winningSum = gameResult.winningDeck.reversed().enumerated().map({($0 + 1) * $1}).reduce(0, +)
        
        return winningSum
    }
    
    // Returns winning deck.
    private func playGame(player1: [Int], player2: [Int]) -> [Int] {
        var p1 = player1
        var p2 = player2
        
        while !p1.isEmpty && !p2.isEmpty {
            let c1 = p1.first!
            let c2 = p2.first!
            p1.remove(at: 0)
            p2.remove(at: 0)
            if c1 > c2 {
                p1.append(contentsOf: [c1, c2])
            } else {
                p2.append(contentsOf: [c2, c1])
            }
        }
        
        return p2.isEmpty ? p1 : p2
    }
    
    // Returns winning deck.
    private struct GameResult {
        let isPlayer1Winner: Bool
        let winningDeck: [Int]
    }
    private func playRecursiveGame(player1: [Int], player2: [Int]) -> GameResult {
        var p1 = player1
        var p2 = player2
        
        var history: Set<[[Int]]> = []
        
        while !p1.isEmpty && !p2.isEmpty && !history.contains([p1, p2]) {
            history.insert([p1, p2])
            
            let c1 = p1.first!
            let c2 = p2.first!
            p1.remove(at: 0)
            p2.remove(at: 0)
            
            let p1WinsRound: Bool
            
            let canRecurse = p1.count >= c1 && p2.count >= c2
            if canRecurse {
                let newP1 = Array(p1[0..<c1])
                let newP2 = Array(p2[0..<c2])
                let recursiveResult = self.playRecursiveGame(player1: newP1, player2: newP2)
                p1WinsRound = recursiveResult.isPlayer1Winner
            } else {
                p1WinsRound = c1 > c2
            }
            
            if p1WinsRound {
                p1.append(contentsOf: [c1, c2])
            } else {
                p2.append(contentsOf: [c2, c1])
            }
        }
        
        if history.contains([p1, p2]) {
            return GameResult(isPlayer1Winner: true, winningDeck: p1)
        }
        
        return GameResult(isPlayer1Winner: p2.isEmpty, winningDeck: p2.isEmpty ? p1 : p2)
    }
}

extension Day22VC: TestableDay {
    func runTests() {
        let testInput =
        """
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
        """.components(separatedBy: "\n\n")
        let parsed = self.parse(testInput)
        let playerCards = parsed.playerCards
        let crabCards = parsed.crabCards
        
        let p1 = self.part1(playerCards: playerCards, crabCards: crabCards)
        assert(p1 == 306)
        
        let p2 = self.part2(playerCards: playerCards, crabCards: crabCards)
        assert(p2 == 291)
    }
}
