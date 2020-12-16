//
//  Day16VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 16/12/2020.
//

import UIKit

class Day16VC: AoCVC, AdventDay, InputLoadable {
    private struct Rule {
        let name: String
        let ranges: [ClosedRange<Int>]
        static func from(_ string: String) -> Rule {
            let split = string.components(separatedBy: ":")
            let name = split[0]
            let rangesComponent = split[1].components(separatedBy: " or ")
            var ranges: [ClosedRange<Int>] = []
            for rangeString in rangesComponent {
                let trimmed = rangeString.trimmingCharacters(in: .whitespacesAndNewlines)
                let split = trimmed.components(separatedBy: "-")
                let range = Int(split[0])!...Int(split[1])!
                ranges.append(range)
            }
            return Rule(name: name, ranges: ranges)
        }
    }
    
    private struct Ticket {
        let fields: [Int]
        static func from(_ string: String) -> Ticket {
            let fields = string.components(separatedBy: ",").map({Int($0)!})
            return Ticket(fields: fields)
            
        }
        
        func scanningErrorRate(rules: [Rule]) -> Int {
            var errorRate = 0
            for i in 0..<self.fields.count {
                errorRate += self.errorRate(fieldIndex: i, rules: rules) ?? 0
            }
            return errorRate
        }
        
        private func errorRate(fieldIndex: Int, rules: [Rule]) -> Int? {
            let field = self.fields[fieldIndex]
            for rule in rules {
                for range in rule.ranges {
                    if range.contains(field) {
                        return nil
                    }
                }
            }
            return field
        }
        
        func isValid(rules: [Rule]) -> Bool {
            for i in 0..<self.fields.count {
                if self.errorRate(fieldIndex: i, rules: rules) != nil {
                    return false
                }
            }
            return true
        }
        
        func isValidStrict(rule: Rule, fieldIndex: Int) -> Bool {
            for range in rule.ranges {
                if range.contains(self.fields[fieldIndex]) {
                    return true
                }
            }
            return false
        }
    }
    
    private var rules: [Rule] = []
    private var yourTicket: Ticket!
    private var nearbyTickets: [Ticket] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray(separator: "\n\n")
        let parsed = self.parse(input)
        self.rules = parsed.rules
        self.yourTicket = parsed.yourTicket
        self.nearbyTickets = parsed.nearbyTickets
    }
    
    private struct ParseResult {
        let rules: [Rule]
        let yourTicket: Ticket
        let nearbyTickets: [Ticket]
    }
    
    private func parse(_ strings: [String]) -> ParseResult {
        let rules = strings[0].components(separatedBy: "\n").map({Rule.from($0)})
        let yourTicket = Ticket.from(strings[1].components(separatedBy: "\n")[1])
        let nearbyTickets = (strings[2].components(separatedBy: "\n")[1...]).map({Ticket.from($0)})
        
        return ParseResult(rules: rules, yourTicket: yourTicket, nearbyTickets: nearbyTickets)
    }
    
    func solveFirst() {
        let result = self.part1(self.rules, self.nearbyTickets)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(self.rules, self.yourTicket, self.nearbyTickets)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(_ rules: [Rule], _ nearbyTickets: [Ticket]) -> Int {
        let errorRate = nearbyTickets.map({$0.scanningErrorRate(rules: rules)}).reduce(0, +)
        return errorRate
    }
    
    private func part2(_ rules: [Rule], _ yourTicket: Ticket, _ nearbyTickets: [Ticket]) -> Int {
        let validNearbyTickets = nearbyTickets.filter({$0.isValid(rules: rules)})
        let allTickets = [yourTicket] + validNearbyTickets
        
        let finalRules = self.generateCorrectRuleOrder(rules: rules, tickets: allTickets)
        
        var product = 1
        for i in 0..<finalRules.count {
            let rule = finalRules[i]
            if rule.name.hasPrefix("departure") {
                product *= yourTicket.fields[i]
            }
        }
        return product
    }
    
    private func generatePotentialIndicesForRule(rules: [Rule], tickets: [Ticket]) -> [Int: [Int]] {
        var positionsForRule: [Int : [Int]] = [:]
        for i in 0..<rules.count {
            let rule = rules[i]
            var validPositions: [Int] = []
            for j in 0..<tickets.first!.fields.count {
                if tickets.allSatisfy({$0.isValidStrict(rule: rule, fieldIndex: j)}) {
                    validPositions.append(j)
                }
            }
            positionsForRule[i] = validPositions
        }
        return positionsForRule
    }
    
    private func generateCorrectRuleOrder(rules: [Rule], tickets: [Ticket]) -> [Rule] {
        var positionsForRule = self.generatePotentialIndicesForRule(rules: rules, tickets: tickets) // Rule index --> potential final indices for rule
        var ruleOrders: [Int : Rule] = [:] // Index --> Rule
        mainLoop: while ruleOrders.count < rules.count {
            for i in 0..<rules.count {
                let validPositions = positionsForRule[i, default: []]
                if validPositions.count == 1 {
                    let actualPosition = validPositions.first!
                    ruleOrders[actualPosition] = rules[i]
                    for j in 0..<rules.count {
                        positionsForRule[j, default: []].removeAll(where: {$0 == actualPosition})
                    }
                    continue mainLoop
                }
            }
        }
        var result: [Rule] = []
        for i in 0..<rules.count {
            result.append(ruleOrders[i]!)
        }
        return result
    }
}

extension Day16VC: TestableDay {
    func runTests() {
        let testInput =
        """
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
        """.components(separatedBy: "\n\n")
        let parsed = self.parse(testInput)
        
        let rules = parsed.rules
        let nearbyTickets = parsed.nearbyTickets
        
        let p1 = self.part1(rules, nearbyTickets)
        assert(p1 == 71)
    }
}
