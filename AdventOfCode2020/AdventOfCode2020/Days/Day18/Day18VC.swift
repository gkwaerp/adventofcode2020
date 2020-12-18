//
//  Day18VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 18/12/2020.
//

import UIKit

class Day18VC: AoCVC, AdventDay, InputLoadable {
    private struct Homework {
        private let tokens: [String]
        
        static func from(_ string: String) -> Homework {
            let spaced = string
                .replacingOccurrences(of: "(", with: "( ")
                .replacingOccurrences(of: ")", with: " )")
            let tokens = spaced.components(separatedBy: " ")
            return Homework(tokens: tokens)
        }
        
        private static func getPrecedence(token: String) -> Int? {
            switch token {
            case "*", "/":
                return 1
            case "+", "-":
                return 1
            default:
                return nil
            }
        }
        
        private static func getPrecedenceAdvanced(token: String) -> Int? {
            switch token {
            case "*", "/":
                return 2
            case "+", "-":
                return 3
            default:
                return nil
            }
        }
        
        func solve(advancedMath: Bool) -> Int {
            let precedence: ReversePolishNotationHelper.PrecedenceBlock = advancedMath ? Self.getPrecedenceAdvanced : Self.getPrecedence
            let rpn = ReversePolishNotationHelper.generateRPN(from: self.tokens, precedenceBlock: precedence)
            return ReversePolishNotationHelper.evaluateRPN(string: rpn)
        }
    }
    
    private var homework: [Homework] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.homework = input.map({Homework.from($0)})
    }
    
    func solveFirst() {
        let result = self.part1(self.homework)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(self.homework)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(_ homework: [Homework]) -> Int {
        return homework.map({$0.solve(advancedMath: false)}).reduce(0, +)
    }
    
    private func part2(_ homework: [Homework]) -> Int {
        return homework.map({$0.solve(advancedMath: true)}).reduce(0, +)
    }
    
    
    private static func getOperatorPrecedence(for token: String, advancedMath: Bool) -> Int? {
        switch token {
        case "*", "/":
            return advancedMath ? 2 : 1
        case "+", "-":
            return advancedMath ? 3 : 1
        default:
            return nil
        }
    }
    
    private enum OperatorAssociativity {
        case left
        case right
    }
    
    private static func getOperatorAssociativity(for token: String) -> OperatorAssociativity {
        return .left
    }
}

extension Day18VC: TestableDay {
    func runTests() {
        let testInput =
        """
        1 + 2 * 3 + 4 * 5 + 6
        1 + (2 * 3) + (4 * (5 + 6))
        2 * 3 + (4 * 5)
        5 + (8 * 3 + 9 + 3 * 4 * 3)
        5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
        ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
        """.components(separatedBy: "\n")
        let homework = testInput.map({Homework.from($0)})
        let expectedResults = [71, 51, 26, 437, 12240, 13632]
        let expectedAdvancedResults = [231, 51, 46, 1445, 669060, 23340]
        assert(homework.count == expectedResults.count)
        assert(homework.count == expectedAdvancedResults.count)
        
        for i in 0..<homework.count {
            assert(homework[i].solve(advancedMath: false) == expectedResults[i])
            assert(homework[i].solve(advancedMath: true) == expectedAdvancedResults[i])
        }
    }
}
