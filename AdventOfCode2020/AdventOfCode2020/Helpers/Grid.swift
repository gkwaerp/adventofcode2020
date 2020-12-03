//
//  Grid.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 30/11/2020.
//

import Foundation

class Grid {
    typealias GridValue = String
    typealias PrintBlock = (GridValue) -> (String?)
    var size: IntPoint
    var values: [GridValue]
    
    var width: Int {
        return self.size.x
    }
    var height: Int {
        return self.size.y
    }
    
    lazy var gridPoints: [IntPoint] = {
        self.size.gridPoints
    }()
    
    convenience init(size: IntPoint, fillWith value: GridValue) {
        let values: [GridValue] = Array(repeating: value, count: size.x * size.y)
        self.init(size: size, values: values)
    }
    
    /// Each element in the array corresponds to 1 row
    convenience init(stringArray: [String]) {
        var values: [Grid.GridValue] = []
        for line in stringArray {
            for char in line {
                values.append(String(char))
            }
        }
        let size = IntPoint(x: stringArray.first!.count, y: stringArray.count)
        self.init(size: size, values: values)
    }
    
    init(size: IntPoint, values: [GridValue]) {
        guard size.x > 0, size.y > 0 else { fatalError("Invalid grid, size must be non-negative in both axes.") }
        guard size.x * size.y == values.count else { fatalError("Invalid grid, values doesn't match size." ) }
        self.size = size
        self.values = values
    }
    
    func updateValues(_ newValues: [GridValue]) {
        guard newValues.count == self.values.count else { fatalError("Can't change size of grid after creation!") }
        self.values = newValues
    }
    
    func getIndex(for position: IntPoint) -> Int? {
        guard position.x < self.width, position.x >= 0 else { return nil }
        guard position.y < self.height, position.y >= 0 else { return nil }
        return position.y * self.width + position.x
    }
    
    func getValue(at position: IntPoint) -> GridValue? {
        guard let index = self.getIndex(for: position) else { return nil }
        return self.values[index]
    }
    
    func setValue(at position: IntPoint, to value: String) {
        guard let index = self.getIndex(for: position) else { return }
        self.values[index] = value
    }
    
    func getValues(offset from: IntPoint, offsets: [IntPoint]) -> [GridValue] {
        return offsets.compactMap({return self.getValue(at: from + $0)})
    }
    
    func getValues(matching filter: (Grid.GridValue) -> (Bool)) -> [Grid.GridValue] {
        return self.values.filter(filter)
    }
    
    private var rawPrintClosure: PrintBlock = { (value) in
        return value
    }

    func asText(printClosure: PrintBlock? = nil) -> String {
        var finalText = "\n"
        for y in 0..<self.height {
            for x in 0..<self.width {
                let printClosure = printClosure ?? self.rawPrintClosure
                if let value = self.getValue(at: IntPoint(x: x, y: y)),
                    let outputString = printClosure(value) {
                    finalText.append(outputString)
                }                }
            finalText.append("\n")
        }
        return finalText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
