//
//  Day05VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 05/12/2020.
//

import UIKit

class Day05VC: AoCVC, AdventDay, InputLoadable {
    private struct Seat {
        let row: Int
        let column: Int
        
        var seatID: Int {
            return (self.row * 8) + self.column
        }
        
        static func from(_ string: String) -> Seat {
            var row = 0...127
            var column = 0...7
            for char in string {
                let rowMid = (row.lowerBound + row.upperBound) / 2
                let colMid = (column.lowerBound + column.upperBound) / 2
                switch char {
                case "F":
                    row = row.lowerBound...rowMid
                case "B":
                    row = (rowMid + 1)...row.upperBound
                case "L":
                    column = column.lowerBound...colMid
                case "R":
                    column = (colMid + 1)...column.upperBound
                default:
                    fatalError()
                }
            }
            guard row.lowerBound == row.upperBound else { fatalError("Invalid row") }
            guard column.lowerBound == column.upperBound else { fatalError("Invalid column") }
            return Seat(row: row.lowerBound, column: column.lowerBound)
        }
    }
    
    private var seats: [Seat] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.seats = input.map({Seat.from($0)})
    }
    
    func solveFirst() {
        let highest = self.seats.map({$0.seatID}).max(by: <)!
        self.setSolution(challenge: 0, text: "\(highest)")
    }
    
    func solveSecond() {
        let seatIDs = Set(self.seats.map({$0.seatID}))
        var mySeatID: Int?
        for seatID in seatIDs {
            if !seatIDs.contains(seatID + 1) && seatIDs.contains(seatID + 2) {
                mySeatID = seatID + 1
                break
            }
        }
        
        guard let mySeatIDUnwrapped = mySeatID else { fatalError("Seat not found") }
        self.setSolution(challenge: 1, text: "\(mySeatIDUnwrapped)")
    }
}

extension Day05VC: TestableDay {
    func runTests() {
        let testInput =
        """
        FBFBBFFRLR
        BFFFBBFRRR
        FFFBBBFRRR
        BBFFBBFRLL
        """.components(separatedBy: "\n")
        let seats = testInput.map({Seat.from($0)})
        assert(seats[0].row == 44 && seats[0].column == 5 && seats[0].seatID == 357)
        assert(seats[1].row == 70 && seats[1].column == 7 && seats[1].seatID == 567)
        assert(seats[2].row == 14 && seats[2].column == 7 && seats[2].seatID == 119)
        assert(seats[3].row == 102 && seats[3].column == 4 && seats[3].seatID == 820)
    }
}
