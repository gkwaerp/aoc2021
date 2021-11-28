//
//  Node.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation

protocol Node {
    var children: [Node] { set get }
    var parent: Node? { set get }
}

extension Node {
    var allParents: [Node] {
        var parents = [Node]()
        var currNode = self.parent
        while let actualNode = currNode {
            parents.append(actualNode)
            currNode = actualNode.parent
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
