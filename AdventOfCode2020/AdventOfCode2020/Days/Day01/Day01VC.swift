//
//  Day01VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 01/12/2020.
//

import UIKit

class Day01VC: AoCVC, AdventDay, InputLoadable {
    private struct Result {
        let values: [Int]
        var product: Int {
            return self.values.reduce(1, *)
        }
    }
    
    private var input: [Int] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray().map({Int($0)!})
    }
    
    func solveFirst() {
        guard let result = self.getResult(from: self.input, searchFor: 2020) else { fatalError("No matching result.") }
        self.setSolution(challenge: 0, text: "\(result.product)")
    }
    
    func solveSecond() {
        guard let result = self.getResult2(from: self.input, searchFor: 2020) else { fatalError("No matching result.") }
        self.setSolution(challenge: 1, text: "\(result.product)")
    }
    
    // Early-out is probably overkill for this input-size...
    private func getResult(from array: [Int], searchFor target: Int) -> Result? {
        let sorted = array.sorted()
        for i in 0..<sorted.count - 1 {
            let a = sorted[i]
            for j in (i + 1)..<sorted.count {
                let b = sorted[j]
                guard a + b <= target else { break }
                if a + b == target {
                    return Result(values: [a, b])
                }
            }
        }
        return nil
    }
    
    // As above.
    private func getResult2(from array: [Int], searchFor target: Int) -> Result? {
        let sorted = array.sorted()
        for i in 0..<sorted.count - 2 {
            let a = sorted[i]
            for j in (i + 1)..<sorted.count - 1 {
                let b = sorted[j]
                guard a + b < target else { break }
                for k in (j + 1)..<sorted.count {
                    let c = sorted[k]
                    guard a + b + c <= target else { break }
                    if a + b + c == target {
                        return Result(values: [a, b, c])
                    }
                }
            }
        }
        return nil
    }
}

extension Day01VC: TestableDay {
    func runTests() {
        let testInput =
            """
            1721
            979
            366
            299
            675
            1456
            """
            .components(separatedBy: "\n")
            .map({Int($0)!})
        
        guard let resultA = self.getResult(from: testInput, searchFor: 2020) else { fatalError() }
        assert(resultA.values.sorted() == [1721, 299].sorted())
        assert(resultA.product == 514579)
        
        guard let resultB = self.getResult2(from: testInput.sorted(), searchFor: 2020) else { fatalError() }
        assert(resultB.values.sorted() == [979, 366, 675].sorted())
        assert(resultB.product == 241861950)
    }
}
