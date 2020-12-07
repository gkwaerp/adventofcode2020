//
//  Day07VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 07/12/2020.
//

import UIKit

class Day07VC: AoCVC, AdventDay, InputLoadable {
    private typealias BagContents = [String : Int] // Name --> Count
    
    private class BagNode {
        let color: String
        let contents: BagContents
        var parents: [BagNode] = []
        var children: [BagNode] = []
        
        init(string: String) {
            let trimmed = string.replacingOccurrences(of: ".", with: "")
            let components = trimmed.components(separatedBy: "bags contain ")
            self.color = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            self.contents = Self.getContents(from: components[1])
        }
        
        private static func getContents(from string: String) -> BagContents {
            guard !string.contains("no other bags") else { return [:] }
            
            let bags = string.components(separatedBy: ", ")
            var contents: BagContents = [:]
            for bag in bags {
                let split = bag.components(separatedBy: " ")
                let count = split[0].intValue!
                let bagColor = split[1...split.count-2].joined(separator: " ")
                contents[bagColor] = count
            }
            return contents
        }
    }
    
    private func createNodes(from input: [String]) -> [BagNode] {
        let nodes = input.map({BagNode(string: $0)})
        
        for node in nodes {
            for containedBag in node.contents {
                guard let containedNode = nodes.first(where: {$0.color == containedBag.key}) else { fatalError() }
                node.children.append(containedNode)
                containedNode.parents.append(node)
            }
        }
        
        return nodes
    }
    
    private var bagNodes: [BagNode] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.bagNodes = self.createNodes(from: input)
    }
    
    private typealias RecursionResult = [(bagNode: BagNode, count: Int)]
    private func getRecursive(startColor: String, nodes: [BagNode], searchParents: Bool, multiplier: Int = 1) -> RecursionResult {
        guard let startNode = nodes.first(where: {$0.color == startColor}) else { fatalError("Can't find bag of requested color") }
        let keyPath = searchParents ? \BagNode.parents : \BagNode.children
        
        var result: RecursionResult = []
        let nodes = startNode[keyPath: keyPath]
        
        for node in nodes {
            result.append((bagNode: node, count: multiplier * startNode.contents[node.color, default: 0]))
            result.append(contentsOf: self.getRecursive(startColor: node.color,
                                                        nodes: nodes,
                                                        searchParents: searchParents,
                                                        multiplier: multiplier * startNode.contents[node.color, default: 0]))
        }
        
        return result
    }
    
    private func countIsContainedWithinBags(innermostBagColor: String, nodes: [BagNode]) -> Int {
        return Set(self.getRecursive(startColor: innermostBagColor, nodes: nodes, searchParents: true).map({$0.bagNode.color})).count
    }
    
    private func countContainedBags(outermostBagColor: String, nodes: [BagNode]) -> Int {
        return self.getRecursive(startColor: outermostBagColor, nodes: nodes, searchParents: false).map({$1}).reduce(0, +)
    }
    
    func solveFirst() {
        let count = self.countIsContainedWithinBags(innermostBagColor: "shiny gold", nodes: self.bagNodes)
        self.setSolution(challenge: 0, text: "\(count)")
    }
    
    func solveSecond() {
        let count = self.countContainedBags(outermostBagColor: "shiny gold", nodes: self.bagNodes)
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
        
        let testNodes = self.createNodes(from: testInput)
        assert(self.countIsContainedWithinBags(innermostBagColor: "shiny gold", nodes: testNodes) == 4)
        assert(self.countContainedBags(outermostBagColor: "shiny gold", nodes: testNodes) == 32)
        
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
        
        let testNodes2 = self.createNodes(from: testInput2)
        assert(self.countContainedBags(outermostBagColor: "shiny gold", nodes: testNodes2) == 126)
    }
}
