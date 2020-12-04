//
//  Day04VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 04/12/2020.
//

import UIKit

class Day04VC: AoCVC, AdventDay, InputLoadable {
    private struct Passport {
        let dic: [String : String]
        
        var isValid: Bool {
            let requiredFields = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
            return requiredFields.allSatisfy({self.dic[$0] != nil})
        }
        
        var isValidStrict: Bool {
            guard self.isValid else { return false }
            return self.dic.keys.allSatisfy({Self.validate(key: $0, value: self.dic[$0]!)})
        }
        
        static func validate(key: String, value: String) -> Bool {
            switch key {
            case "byr":
                return (1920...2002).contains(value.intValue!)
            case "iyr":
                return (2010...2020).contains(value.intValue!)
            case "eyr":
                return (2020...2030).contains(value.intValue!)
            case "hgt":
                let hgt = String(value.dropLast(2)).intValue!
                if value.hasSuffix("in") {
                    return (59...76).contains(hgt)
                } else if value.hasSuffix("cm") {
                    return (150...193).contains(hgt)
                } else {
                    return false
                }
            case "hcl":
                guard value.hasPrefix("#") && value.count == 7 else { return false}
                let validHCL = "0123456789abcdef"
                return String(value.dropFirst())
                    .trimmingCharacters(in: CharacterSet(charactersIn: validHCL).inverted)
                    .count == 6
            case "ecl":
                let validECL = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
                return validECL.contains(value)
            case "pid":
                return value.intValue != nil && value.count == 9
            default:
                return true
            }
        }
        
        static func from(_ string: String) -> Passport {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let keyValues = trimmed.components(separatedBy: " ")
            var dic: [String : String] = [:]
            for keyvalue in keyValues {
                let split = keyvalue.components(separatedBy: ":")
                dic[split[0]] = split[1]
            }
            return Passport(dic: dic)
        }
    }
    
    private var passports: [Passport] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray(separator: "\n\n" ,includeEmptyLines: true)
        let passportStrings = self.generatePassportStrings(from: input)
        self.passports = passportStrings.map({Passport.from($0)})
    }
    
    private func generatePassportStrings(from input: [String]) -> [String] {
        return input.map({$0.replacingOccurrences(of: "\n", with: " ")})
    }
    
    func solveFirst() {
        let result = self.passports.filter({$0.isValid}).count
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.passports.filter({$0.isValidStrict}).count
        self.setSolution(challenge: 1, text: "\(result)")
    }
}

extension Day04VC: TestableDay {
    func runTests() {
        let testInput1 =
        """
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm

        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm

        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
        """.components(separatedBy: "\n\n")
        
        let passports1 = self.generatePassportStrings(from: testInput1).map({Passport.from($0)})
        assert(passports1.count == 4)
        assert(passports1[0].isValid)
        assert(!passports1[1].isValid)
        assert(passports1[2].isValid)
        assert(!passports1[3].isValid)
        
        assert(Passport.validate(key: "byr", value: "2002"))
        assert(!Passport.validate(key: "byr", value: "2003"))
        
        assert(Passport.validate(key: "hgt", value: "60in"))
        assert(Passport.validate(key: "hgt", value: "190cm"))
        assert(!Passport.validate(key: "hgt", value: "190in"))
        assert(!Passport.validate(key: "hgt", value: "190"))
        
        assert(Passport.validate(key: "hcl", value: "#123abc"))
        assert(!Passport.validate(key: "hcl", value: "#123abz"))
        assert(!Passport.validate(key: "hcl", value: "123abc"))
        
        assert(Passport.validate(key: "ecl", value: "brn"))
        assert(!Passport.validate(key: "ecl", value: "wat"))
        
        assert(Passport.validate(key: "pid", value: "000000001"))
        assert(!Passport.validate(key: "pid", value: "0123456789"))

        let testInvalidInput =
        """
        eyr:1972 cid:100
        hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

        iyr:2019
        hcl:#602927 eyr:1967 hgt:170cm
        ecl:grn pid:012533040 byr:1946

        hcl:dab227 iyr:2012
        ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

        hgt:59cm ecl:zzz
        eyr:2038 hcl:74454a iyr:2023
        pid:3556412378 byr:2007
        """.components(separatedBy: "\n\n")
        
        let invalidPassports = self.generatePassportStrings(from: testInvalidInput).map({Passport.from($0)})
        assert(invalidPassports.allSatisfy({!$0.isValidStrict}))
        
        let testValidInput =
        """
        pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
        hcl:#623a2f

        eyr:2029 ecl:blu cid:129 byr:1989
        iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

        hcl:#888785
        hgt:164cm byr:2001 iyr:2015 cid:88
        pid:545766238 ecl:hzl
        eyr:2022

        iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
        """.components(separatedBy: "\n\n")
        let validPassports = self.generatePassportStrings(from: testValidInput).map({Passport.from($0)})
        assert(validPassports.allSatisfy({$0.isValidStrict}))
    }
}
