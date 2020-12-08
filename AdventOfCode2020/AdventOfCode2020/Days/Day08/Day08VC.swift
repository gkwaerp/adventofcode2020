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
    
    private struct Instruction {
        let operation: Operation
        let id = UUID().uuidString
        
        static func from(_ string: String) -> Instruction {
            return Instruction(operation: Operation.from(string))
        }
    }
    
    private var instructions: [Instruction] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.instructions = input.map({Instruction.from($0)})
    }
    
    func solveFirst() {
        let result = "\(self.run(instructions: self.instructions).accumulator)"
        self.setSolution(challenge: 0, text: result)
    }
    
    func solveSecond() {
        let result = "\(self.runFixed(instructions: self.instructions))"
        self.setSolution(challenge: 1, text: result)
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
    
    private func run(instructions: [Instruction]) -> RunResult {
        var accumulator = 0
        var instructionPointer = 0
        var seenInstructions: Set<String> = []
        
        while true {
            guard instructionPointer < instructions.count else {
                let exitCode: RunResult.ExitCode = (instructionPointer == instructions.count) ? .success : .invalidTermination
                return RunResult(exitCode: exitCode, accumulator: accumulator)
            }
            let instruction = instructions[instructionPointer]
            guard seenInstructions.insert(instruction.id).inserted else { return RunResult(exitCode: .infiniteLoop, accumulator: accumulator) }
            
            switch instruction.operation {
            case .jmp(let value):
                instructionPointer += value
            case .acc(let value):
                accumulator += value
                instructionPointer += 1
            case .nop:
                instructionPointer += 1
            }
        }
        fatalError()
    }
    
    private func runFixed(instructions: [Instruction]) -> Int {
        for i in 0..<instructions.count {
            var instructions = instructions
            switch instructions[i].operation {
            case .jmp(let value):
                instructions[i] = Instruction(operation: .nop(value: value))
            case .nop(let value):
                instructions[i] = Instruction(operation: .jmp(value: value))
            case .acc:
                continue
            }
            
            let run = self.run(instructions: instructions)
            if run.exitCode == .success {
                return run.accumulator
            }
        }
        fatalError()
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
        let testInstructions = testInput.map({Instruction.from($0)})
        
        assert(self.run(instructions: testInstructions).accumulator == 5)
        assert(self.runFixed(instructions: testInstructions) == 8)
    }
}
