//
//  DateHelper.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import Foundation

class DateHelper {
    static func getElapsedTimeString(from date: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(date)
        return String(format: "Time = %.4f", elapsedTime)
    }
}
