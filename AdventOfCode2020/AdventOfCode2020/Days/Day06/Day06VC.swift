//
//  Day06VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 06/12/2020.
//

import UIKit

class Day06VC: AoCVC, AdventDay, InputLoadable {
    private struct Person {
        let answers: Set<String>
    }
    
    private struct Group {
        private var people: [Person]
        
        private var allAnswers: Set<String> {
            return people.map({$0.answers}).reduce(Set(), {$0.union($1)})
        }
        
        var anyoneAnswered: Set<String> {
            return self.allAnswers
        }
        
        var everyoneAnswered: Set<String> {
            return self.allAnswers.filter { (answer) -> Bool in
                self.people.allSatisfy({$0.answers.contains(answer)})
            }
        }
        
        static func from(_ string: String) -> Group {
            let people = string
                .components(separatedBy: "\n")
                .map{Person(answers: Set($0.asStringArray))}
            return Group(people: people)
        }
    }
    
    private var groups: [Group] = []
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray(separator: "\n\n")
        self.groups = input.map({Group.from($0)})
    }
    
    private func countAny(in groups: [Group]) -> Int {
        return groups.map({$0.anyoneAnswered.count}).reduce(0, +)
    }
    
    private func countEvery(in groups: [Group]) -> Int {
        groups.map({$0.everyoneAnswered.count}).reduce(0, +)
    }
    
    func solveFirst() {
        self.setSolution(challenge: 0, text: "\(self.countAny(in: self.groups))")
    }
    
    func solveSecond() {
        self.setSolution(challenge: 1, text: "\(self.countEvery(in: self.groups))")
    }
}

extension Day06VC: TestableDay {
    func runTests() {
        let testInput =
        """
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
        """.components(separatedBy: "\n\n")
        let groups = testInput.map({Group.from($0)})
        let anyCount = self.countAny(in: groups)
        let everyCount = self.countEvery(in: groups)
        assert(anyCount == 11)
        assert(everyCount == 6)
    }
}
