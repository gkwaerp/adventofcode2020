//
//  Day02VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 02/12/2020.
//

import UIKit

class Day02VC: AoCVC, AdventDay, InputLoadable {
    private struct PasswordInfo {
        let lower: Int
        let upper: Int
        let character: String
        let password: String
        
        var isValid: Bool {
            let numOccurrences = self.password.count - self.password.replacingOccurrences(of: self.character, with: "").count
            return (self.lower...self.upper).contains(numOccurrences)
        }
        
        var isValidNewPolicy: Bool {
            let arrayed = self.password.toStringArray()
            let containsLower = arrayed[self.lower - 1] == self.character
            let containsUpper = arrayed[self.upper - 1] == self.character
            return containsLower != containsUpper
        }
        
        static func from(string: String) -> PasswordInfo {
            let split = string.replacingOccurrences(of: ":", with: "").components(separatedBy: " ")
            let range = split[0].components(separatedBy: "-").map({Int($0)!})
            let character = split[1]
            let password = split[2]
            
            return PasswordInfo(lower: range[0], upper: range[1], character: character, password: password)
        }
    }
    
    private var passwords: [PasswordInfo] = []

    func loadInput() {
        self.passwords = self.defaultInputFileString.loadAsTextStringArray().map({PasswordInfo.from(string: $0)})
    }
    
    func solveFirst() {
        let valid = self.passwords.filter({$0.isValid})
        self.setSolution(challenge: 0, text: "\(valid.count)")
    }
    
    func solveSecond() {
        let valid = self.passwords.filter({$0.isValidNewPolicy})
        self.setSolution(challenge: 1, text: "\(valid.count)")
    }
}

extension Day02VC: TestableDay {
    func runTests() {
        let passwords =
        """
        1-3 a: abcde
        1-3 b: cdefg
        2-9 c: ccccccccc
        """.components(separatedBy: "\n").map({PasswordInfo.from(string: $0)})
        assert(passwords[0].isValid)
        assert(!passwords[1].isValid)
        assert(passwords[2].isValid)
        
        assert(passwords[0].isValidNewPolicy)
        assert(!passwords[1].isValidNewPolicy)
        assert(!passwords[2].isValidNewPolicy)
    }
}
