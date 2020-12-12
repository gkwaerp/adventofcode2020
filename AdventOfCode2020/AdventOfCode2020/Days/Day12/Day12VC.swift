//
//  Day12VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 12/12/2020.
//

import UIKit

class Day12VC: AoCVC, AdventDay, InputLoadable {
    private enum Instruction {
        case north(value: Int)
        case south(value: Int)
        case east(value: Int)
        case west(value: Int)
        case forward(value: Int)
        case left(angle: Int)
        case right(angle: Int)
        
        static func from(_ string: String) -> Instruction {
            let arrayed = string.asStringArray
            let value = Int(arrayed[1...].joined())!
            switch arrayed[0] {
            case "N":
                return .north(value: value)
            case "S":
                return .south(value: value)
            case "E":
                return .east(value: value)
            case "W":
                return .west(value: value)
            case "F":
                return .forward(value: value)
            case "L":
                return value > 0 ? .left(angle: value) : .right(angle: abs(value))
            case "R":
                return value > 0 ? .right(angle: value) : .left(angle: abs(value))
            default:
                fatalError()
            }
        }
    }
    
    private var instructions: [Instruction] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.instructions = input.map({Instruction.from($0)})
    }
    
    func solveFirst() {
        let result = self.part1(with: self.instructions)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(with: self.instructions)
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func part1(with instructions: [Instruction]) -> Int {
        var shipPos = IntPoint.origin
        var facingDirection: Direction = .east
        for instruction in instructions {
            switch instruction {
            case .north(value: let value):
                shipPos = shipPos.move(in: .north, numSteps: value)
            case .south(value: let value):
                shipPos = shipPos.move(in: .south, numSteps: value)
            case .east(value: let value):
                shipPos = shipPos.move(in: .east, numSteps: value)
            case .west(value: let value):
                shipPos = shipPos.move(in: .west, numSteps: value)
            case .forward(value: let value):
                shipPos = shipPos.move(in: facingDirection, numSteps: value)
            case .left(angle: let angle):
                let numTurns = angle / 90
                for _ in 0..<numTurns {
                    facingDirection.turn(left: true)
                }
            case .right(angle: let angle):
                let numTurns = angle / 90
                for _ in 0..<numTurns {
                    facingDirection.turn(left: false)
                }
            }
        }
        return shipPos.manhattanDistance(to: .origin)
    }
    
    private func part2(with instructions: [Instruction]) -> Int {
        var shipPos = IntPoint.origin
        var waypointOffset = IntPoint(north: 1, east: 10)
        for instruction in instructions {
            switch instruction {
            case .north(value: let value):
                waypointOffset = waypointOffset.move(in: .north, numSteps: value)
            case .south(value: let value):
                waypointOffset = waypointOffset.move(in: .south, numSteps: value)
            case .east(value: let value):
                waypointOffset = waypointOffset.move(in: .east, numSteps: value)
            case .west(value: let value):
                waypointOffset = waypointOffset.move(in: .west, numSteps: value)
            case .forward(value: let value):
                shipPos += waypointOffset.scaled(by: value)
            case .left(angle: let angle):
                let numTurns = angle / 90
                for _ in 0..<numTurns {
                    waypointOffset = waypointOffset.rotate(around: .origin, left: true)
                }
            case .right(angle: let angle):
                let numTurns = angle / 90
                for _ in 0..<numTurns {
                    waypointOffset = waypointOffset.rotate(around: .origin, left: false)
                }
            }
        }
        return shipPos.manhattanDistance(to: .origin)
    }
}

extension Day12VC: TestableDay {
    func runTests() {
        let testInput =
        """
        F10
        N3
        F7
        R90
        F11
        """.components(separatedBy: "\n")
        let instructions = testInput.map({Instruction.from($0)})
        let p1 = self.part1(with: instructions)
        let p2 = self.part2(with: instructions)
        
        assert(p1 == 25)
        assert(p2 == 286)
    }
}
