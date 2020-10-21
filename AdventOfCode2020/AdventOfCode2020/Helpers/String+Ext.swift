//
//  String+Ext.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import Foundation

extension String {
    func toStringArray() -> [String] {
        return self.map({"\($0)"})
    }
    
    func loadAsTextLines(fileType: String? = nil) -> [String] {
        return FileLoader.loadTextLines(fileName: self, fileType: fileType)
    }
    
    func loadAsTextFirstLine(fileType: String? = nil) -> String {
        return self.loadAsTextLines().first!
    }
    
    func loadJSON<T: Codable>(fileType: String? = nil, parseType: T.Type) -> T {
        return FileLoader.loadJSON(fileName: self, fileType: fileType, parseType: parseType)
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var boolValue: Bool? {
        if self.lowercased() == "true" {
            return true
        } else if self.lowercased() == "false" {
            return false
        }
        if let intValue = self.intValue {
            return intValue != 0
        }
        return nil
    }
}
