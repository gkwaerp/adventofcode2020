//
//  ReversePolishNotationHelper.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 18/12/2020.
//

import Foundation

class ReversePolishNotationHelper {
    enum OperatorAssociativity {
        case left
        case right
    }
    
    typealias PrecedenceBlock = (String) -> (Int?)
    typealias AssociativityBlock = (String) -> OperatorAssociativity
    typealias IntOperatorFunction = (Int, Int) -> Int
    typealias IntOperatorBlock = (String) -> IntOperatorFunction?

    private static func defaultIntOperator(operatorToken: String) -> IntOperatorFunction? {
        switch operatorToken {
        case "*": return (*)
        case "/": return (/)
        case "+": return (+)
        case "-": return (-)
        default: return nil
        }
    }
    
    private static func defaultPrecedence(operatorToken: String) -> Int? {
        switch operatorToken {
        case "*": return 3
        case "/": return 3
        case "+": return 2
        case "-": return 2
        default: return nil
        }
    }
    
    private static func defaultAssociativity(operatorToken: String) -> OperatorAssociativity {
        return .left
    }
    
    // Shunting-yard
    static func generateRPN(from tokens: [String],
                            precedenceBlock: PrecedenceBlock = ReversePolishNotationHelper.defaultPrecedence,
                            associativityBlock: AssociativityBlock = ReversePolishNotationHelper.defaultAssociativity) -> String {
        var currTokens = tokens
        var output = ""
        var operatorQueue: [String] = []
        while let currToken = currTokens.first {
            currTokens.remove(at: 0)
            if let intValue = currToken.intValue {
                output += "\(intValue) "
            } else if currToken == "(" {
                operatorQueue.append(currToken)
            } else if currToken == ")" {
                while let topOperator = operatorQueue.last, topOperator != "(" {
                    output += "\(topOperator) "
                    _ = operatorQueue.popLast()
                }
                if operatorQueue.last == "(" {
                    _ = operatorQueue.popLast()
                }
            } else {
                guard let currPrecedence = precedenceBlock(currToken) else { fatalError("Invalid operator token") }
                while let topOperator = operatorQueue.last,
                      let topPrecedence = precedenceBlock(topOperator),
                      (topPrecedence > currPrecedence)
                        || (topPrecedence == currPrecedence && associativityBlock(currToken) == .left),
                      topOperator != "(" {
                    output += "\(topOperator) "
                    _ = operatorQueue.popLast()
                }
                
                operatorQueue.append(currToken)
            }
        }
        
        while let topOperator = operatorQueue.popLast() {
            guard !"()".contains(topOperator) else { fatalError("Mismatched parentheses") }
            output += "\(topOperator) "
        }
        
        return output
    }
    
    static func evaluateRPN(string: String,
                            intOperatorClosure: IntOperatorBlock = ReversePolishNotationHelper.defaultIntOperator) -> Int {
        let tokens = string.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        var stack: [Int] = []
        for token in tokens {
            switch token {
            case "+", "-", "*", "/":
                guard let function = intOperatorClosure(token) else { fatalError("Unsupported operator token") }
                let y = stack.popLast()!
                let x = stack.popLast()!
                let eval = function(x, y)
                stack.append(eval)
            default:
                stack.append(token.intValue!)
            }
        }
        assert(stack.count == 1)
        return stack.first!
    }
}
