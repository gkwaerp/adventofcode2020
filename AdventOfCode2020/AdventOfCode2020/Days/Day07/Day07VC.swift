//
//  Day07VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 07/12/2020.
//

import UIKit

class Day07VC: AoCVC, AdventDay, InputLoadable {
    private struct BagRule {
        let bagColor: String
        let contents: [String: Int] // Bag color --> Count
        
        static func from(_ string: String) -> BagRule? {
            let trimmed = string.replacingOccurrences(of: ".", with: "")
            guard !trimmed.hasSuffix("no other bags") else { return nil }
            let components = trimmed.components(separatedBy: "bags contain ")
            let bagColor = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let bags = components[1].components(separatedBy: ", ")
            var contents: [String : Int] = [:]
            for bag in bags {
                let split = bag.components(separatedBy: " ")
                let count = split[0].intValue!
                let bagColor = split[1...split.count-2].joined(separator: " ")
                contents[bagColor] = count
            }
            return BagRule(bagColor: bagColor, contents: contents)
        }
    }
    
    private var bagRules: [BagRule] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.bagRules = input.compactMap({BagRule.from($0)})
    }
    
    private func countIsContainedWithin(bagColor: String, using bagRules: [BagRule]) -> Int {
        var bagsToCheckFor: Set<String> = [bagColor]
        var checkedBags: Set<String> = []
        
        var containingBags: Set<String> = []
        
        while let bagToCheckFor = bagsToCheckFor.popFirst() {
            checkedBags.insert(bagToCheckFor)
            for bagRule in bagRules {
                if bagRule.contents[bagToCheckFor] != nil {
                    containingBags.insert(bagRule.bagColor)
                    if !checkedBags.contains(bagRule.bagColor) {
                        bagsToCheckFor.insert(bagRule.bagColor)
                    }
                }
            }
        }
        
        return containingBags.count
    }
    
    private func countNestedBags(in bagColor: String, using bagRules: [BagRule]) -> Int {
        guard let bagRule = bagRules.first(where: {$0.bagColor == bagColor}) else { return 0 }
        var count = 0
        for bagKey in bagRule.contents.keys {
            count += bagRule.contents[bagKey]! * (1 + self.countNestedBags(in: bagKey, using: bagRules))
        }
        return count
    }
    
    func solveFirst() {
        let count = self.countIsContainedWithin(bagColor: "shiny gold", using: self.bagRules)
        self.setSolution(challenge: 0, text: "\(count)")
    }
    
    func solveSecond() {
        let count = self.countNestedBags(in: "shiny gold", using: self.bagRules)
        self.setSolution(challenge: 1, text: "\(count)")
    }
}

extension Day07VC: TestableDay {
    func runTests() {
        let testInput =
        """
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
        """.components(separatedBy: "\n")
        let bagRules = testInput.compactMap({BagRule.from($0)})
        
        assert(self.countIsContainedWithin(bagColor: "shiny gold", using: bagRules) == 4)
        assert(self.countNestedBags(in: "shiny gold", using: bagRules) == 32)
        
        let testInput2 =
        """
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.
        """.components(separatedBy: "\n")
        let bagRules2 = testInput2.compactMap({BagRule.from($0)})
        assert(self.countNestedBags(in: "shiny gold", using: bagRules2) == 126)
    }
}
