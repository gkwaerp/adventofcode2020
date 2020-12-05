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
        
        static func fromBinarySearch(_ string: String) -> Seat {
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
        
        static func fromBinaryConversion(_ string: String) -> Seat {
            let binary = string.map({"BR".contains($0) ? "1" : "0"}).joined()
            let seatID = Int(binary, radix: 2)!
            let column = seatID % 8
            let row = (seatID - column) / 8
            return Seat(row: row, column: column)
        }
    }
    
    private var seats: [Seat] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.seats = input.map({Seat.fromBinaryConversion($0)})
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
        let seatsBinaryConversion = testInput.map({Seat.fromBinaryConversion($0)})
        let seatsBinarySearch = testInput.map({Seat.fromBinarySearch($0)})
        assert(seatsBinarySearch.count == seatsBinaryConversion.count)
        for i in 0..<seatsBinarySearch.count {
            assert(seatsBinarySearch[i].row == seatsBinaryConversion[i].row)
            assert(seatsBinarySearch[i].column == seatsBinaryConversion[i].column)
            assert(seatsBinarySearch[i].seatID == seatsBinaryConversion[i].seatID)
        }
        assert(seatsBinarySearch[0].row == 44 && seatsBinarySearch[0].column == 5 && seatsBinarySearch[0].seatID == 357)
        assert(seatsBinarySearch[1].row == 70 && seatsBinarySearch[1].column == 7 && seatsBinarySearch[1].seatID == 567)
        assert(seatsBinarySearch[2].row == 14 && seatsBinarySearch[2].column == 7 && seatsBinarySearch[2].seatID == 119)
        assert(seatsBinarySearch[3].row == 102 && seatsBinarySearch[3].column == 4 && seatsBinarySearch[3].seatID == 820)
    }
}
