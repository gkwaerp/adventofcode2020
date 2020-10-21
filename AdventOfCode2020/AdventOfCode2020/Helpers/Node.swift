//
//  Node.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import Foundation

protocol Node {
    var children: [Node] { set get }
    var parent: Node? { set get }
}

extension Node {
    var allParents: [Node] {
        var parents = [Node]()
        var checkingNode = self.parent
        while checkingNode != nil {
            parents.append(checkingNode!)
            checkingNode = checkingNode?.parent
        }
        return parents
    }

    var allChildren: [Node] {
        var allChildren = [Node]()
        for child in self.children {
            allChildren.append(contentsOf: child.allChildren)
        }
        return allChildren
    }
}
