//
//  Day14VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 14/12/2020.
//

import UIKit

class Day14VC: AoCVC, AdventDay, InputLoadable {
    private var rawInput: [String] = []
    private typealias Memory = [Int : Int] // Address --> Value
    
    func loadInput() {
        self.rawInput = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    func solveFirst() {
        let result = self.part1(self.rawInput)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(self.rawInput)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(_ instructions: [String]) -> Int {
        var memory: Memory = [:]
        var mask = ""
        for instruction in instructions {
            let components = instruction.components(separatedBy: " = ")
            if components[0].hasPrefix("mask") {
                mask = components[1]
            } else {
                let comp2 = components[0].replacingOccurrences(of: "[", with: " ")
                    .replacingOccurrences(of: "]", with: " ")
                    .components(separatedBy: " ")
                let address = Int(comp2[1])!
                let value = Int(components[1])!
                
                self.write(value: value, address: address, mask: mask, memory: &memory)
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    private func write(value: Int, address: Int, mask: String, memory: inout Memory) {
        let binaryString = String(value, radix: 2).asStringArray
        let maskArray = mask.asStringArray
        var writtenValue = ""
        for i in 0..<maskArray.count {
            let maskChar = maskArray[maskArray.count - (1 + i)]
            switch maskChar {
            case "X":
                if (binaryString.count - (1 + i)) < 0 {
                    writtenValue = "0" + writtenValue
                } else {
                    let orignalValue = binaryString[binaryString.count - (1 + i)]
                    writtenValue = orignalValue + writtenValue
                }
            case "0":
                writtenValue = "0" + writtenValue
            case "1":
                writtenValue = "1" + writtenValue
            default:
                fatalError()
            }
        }
        
        memory[address] = Int(writtenValue, radix: 2)
    }
    
    private func part2(_ instructions: [String]) -> Int {
        var memory: [Int : Int] = [:]
        var mask = ""
        for instruction in instructions {
            let components = instruction.components(separatedBy: " = ")
            if components[0].hasPrefix("mask") {
                mask = components[1]
            } else {
                let comp2 = components[0].replacingOccurrences(of: "[", with: " ")
                    .replacingOccurrences(of: "]", with: " ")
                    .components(separatedBy: " ")
                let intAddress = Int(comp2[1])!
                let value = Int(components[1])!
                
                let binaryAddress = String(intAddress, radix: 2)
                self.write2(value: value, address: binaryAddress, mask: mask, memory: &memory)
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    private func write2(value: Int, address: String, mask: String, memory: inout [Int : Int]) {
        let maskArray = mask.asStringArray
        var writtenAddress = ""
        
        let addressArray = address.asStringArray
        for i in 0..<maskArray.count {
            let maskChar = maskArray[maskArray.count - (1 + i)]
            switch maskChar {
            case "X":
                writtenAddress = "X" + writtenAddress
            case "0":
                if (addressArray.count - (1 + i)) < 0 {
                    writtenAddress = "0" + writtenAddress
                } else {
                    writtenAddress = addressArray[addressArray.count - (1 + i)] + writtenAddress
                }
            case "1":
                writtenAddress = "1" + writtenAddress
            default:
                fatalError()
            }
        }
        
        let addresses = self.generateAddresses(from: writtenAddress)
        for address in addresses {
            memory[address] = value
        }
    }
    
    private func generateAddresses(from maskedAddress: String) -> [Int] {
        var result: [String] = []

        let numFloating = maskedAddress.filter({$0 == "X"}).count
        let numPermutations = Int(pow(2.0, Double(numFloating)))
        let arrayed = maskedAddress.asStringArray
        
        for permutation in 0..<numPermutations {
            var address = ""
            var floatingIndex = 0
            for i in 0..<arrayed.count {
                if arrayed[i] == "X" {
                    let shifted = (permutation >> floatingIndex) % 2
                    address += "\(shifted)"
                    floatingIndex += 1
                } else {
                    address += arrayed[i]
                }
            }
            result.append(address)
        }
        
        return result.map({Int($0, radix: 2)!})
    }
}

extension Day14VC: TestableDay {
    func runTests() {
        let testInput =
        """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """.components(separatedBy: "\n")
        let p1 = self.part1(testInput)
        
        let testInput2 =
        """
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1
        """.components(separatedBy: "\n")
        let p2 = self.part2(testInput2)

        assert(p1 == 165)
        assert(p2 == 208)
    }
}
