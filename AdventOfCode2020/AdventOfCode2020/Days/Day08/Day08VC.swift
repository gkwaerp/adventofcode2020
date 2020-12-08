//
//  Day08VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 08/12/2020.
//

import UIKit

class Day08VC: AoCVC, AdventDay, InputLoadable {
    private enum Operation {
        case acc(value: Int)
        case jmp(value: Int)
        case nop(value: Int)
        
        static func from(_ string: String) -> Operation {
            let components = string.components(separatedBy: " ")
            let value = Int(components[1])!
            switch components[0] {
            case "acc":
                return .acc(value: value)
            case "jmp":
                return .jmp(value: value)
            case "nop":
                return .nop(value: value)
            default:
                fatalError()
            }
        }
    }
    
    private var operations: [Operation] = []
    
    private class Program {
        enum ExitCode {
            case success
            case infiniteLoop
            case invalidTermination
        }
        
        var accumulator = 0
        private var instructionPointer = 0
        private var seenInstructionIndices: Set<Int> = []
        
        @discardableResult
        func resetAndRun(with operations: [Operation]) -> ExitCode {
            self.reset()
            return self.run(with: operations)
        }
        
        private func run(with operations: [Operation]) -> ExitCode {
            while true {
                guard self.instructionPointer <= operations.count else { return .invalidTermination }
                guard self.instructionPointer != operations.count else { break }
                let operation = operations[self.instructionPointer]
                guard self.seenInstructionIndices.insert(self.instructionPointer).inserted else { return .infiniteLoop }
                switch operation {
                case .jmp(let value):
                    self.instructionPointer += value
                case .acc(let value):
                    self.accumulator += value
                    self.instructionPointer += 1
                case .nop:
                    self.instructionPointer += 1
                }
            }
            return .success
        }
        
        private func reset() {
            self.accumulator = 0
            self.instructionPointer = 0
            self.seenInstructionIndices.removeAll(keepingCapacity: true)
        }
    }
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.operations = input.map({Operation.from($0)})
    }
    
    func solveFirst() {
        let result = self.run(operations: self.operations)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.runFixed(operations: self.operations)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private struct RunResult {
        enum ExitCode {
            case infiniteLoop
            case invalidTermination
            case success
        }
        let exitCode: ExitCode
        let accumulator: Int
    }
    
    private func run(operations: [Operation]) -> Int {
        let program = Program()
        program.resetAndRun(with: operations)
        return program.accumulator
    }
    
    private func runFixed(operations: [Operation]) -> Int {
        let program = Program()
        for i in 0..<operations.count {
            var operations = operations
            switch operations[i] {
            case .jmp(let value):
                operations[i] = .nop(value: value)
            case .nop(let value):
                operations[i] = .jmp(value: value)
            case .acc:
                continue
            }
            
            let result = program.resetAndRun(with: operations)
            if result == .success {
                return program.accumulator
            }
        }
        fatalError("No fix detected.")
    }
}

extension Day08VC: TestableDay {
    func runTests() {
        let testInput =
        """
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
        """.components(separatedBy: "\n")
        let testOperations = testInput.map({Operation.from($0)})
        
        assert(self.run(operations: testOperations) == 5)
        assert(self.runFixed(operations: testOperations) == 8)
    }
}
