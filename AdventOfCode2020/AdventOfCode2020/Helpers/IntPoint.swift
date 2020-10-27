//
//  IntPoint.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import Foundation

class IntPoint: Equatable, Hashable, CustomStringConvertible {
    var description: String {
        return "X: \(self.x), Y: \(self.y)"
    }
    
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    static func == (lhs: IntPoint, rhs: IntPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func copy() -> IntPoint {
        return IntPoint(x: self.x, y: self.y)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
    
    static var origin: IntPoint {
        return IntPoint(x: 0, y: 0)
    }
    
    func manhattanDistance(to other: IntPoint) -> Int {
        return abs(self.x - other.x) + abs(self.y - other.y)
    }
    
    func scaled(by scalar: Int) -> IntPoint {
        return self.scaled(xScale: scalar, yScale: scalar)
    }
    
    func scaled(xScale: Int, yScale: Int) -> IntPoint {
        return IntPoint(x: self.x * xScale, y: self.y * yScale)
    }

    func move(in direction: Direction, numSteps: Int) -> IntPoint {
        return self + direction.movementVector.scaled(by: numSteps)
    }

    func magnitude() -> Int {
        return abs(self.x) + abs(self.y)
    }
    
    static func +(lhs: IntPoint, rhs: IntPoint) -> IntPoint {
        return IntPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: IntPoint, rhs: IntPoint) -> IntPoint {
        return IntPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout IntPoint, rhs: IntPoint) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout IntPoint, rhs: IntPoint) {
        lhs = lhs - rhs
    }
    
    static func angle(between a: IntPoint, and b: IntPoint, invertY: Bool) -> Double? {
        guard a != b else { return nil }
        let delta = b - a
        let x = Double(delta.x)
        let y = invertY ? Double(-delta.y) : Double(delta.y)
        return atan2(x, y)
    }
    
    static func angleInDegrees(between a: IntPoint, and b: IntPoint, invertY: Bool) -> Double? {
        guard let radians = IntPoint.angle(between: a, and: b, invertY: invertY) else { return nil }
        return (radians * 180.0 / Double.pi)
    }

    static func gridInfo<T: Collection>(from coordinates: T) -> GridInfo where T.Element: IntPoint {
        guard coordinates.count > 0 else {
            return GridInfo.zero
        }

        let minExtents = coordinates.first!.copy()
        let maxExtents = coordinates.first!.copy()

        for point in coordinates {
            let intPoint = point as IntPoint

            minExtents.x = min(minExtents.x, intPoint.x)
            maxExtents.x = max(maxExtents.x, intPoint.x)
            minExtents.y = min(minExtents.y, intPoint.y)
            maxExtents.y = max(maxExtents.y, intPoint.y)
        }

        return GridInfo(minExtents: minExtents, maxExtents: maxExtents)
    }

    static func gridPoints(x: Int, y: Int) -> [IntPoint] {
        var allPoints = [IntPoint]()
        for yPos in 0..<y {
            for xPos in 0..<x {
                allPoints.append(IntPoint(x: xPos, y: yPos))
            }
        }
        return allPoints
    }
}

struct GridInfo {
    let minExtents: IntPoint
    let maxExtents: IntPoint
    
    var width: Int {
        return self.maxExtents.x - self.minExtents.x + 1
    }
    
    var height: Int {
        return self.maxExtents.y - self.minExtents.y + 1
    }

    static var zero: GridInfo {
        return GridInfo(minExtents: .origin, maxExtents: .origin)
    }

    var allPoints: [IntPoint] {
        let rawPoints = IntPoint.gridPoints(x: self.width, y: self.height)
        return rawPoints.map({minExtents + $0})
    }
}
