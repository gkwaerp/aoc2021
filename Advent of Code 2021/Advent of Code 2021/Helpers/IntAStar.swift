//
//  IntAStar.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation

class AStarEdge {
    var fromNode: AStarNode
    var toNode: AStarNode
    var cost: Int
    
    init(from: AStarNode, to: AStarNode, cost: Int) {
        self.fromNode = from
        self.toNode = to
        self.cost = cost
    }
}

extension AStarEdge: Hashable, Equatable {
    static func == (lhs: AStarEdge, rhs: AStarEdge) -> Bool {
        return lhs.fromNode == rhs.fromNode &&
            lhs.toNode == rhs.toNode &&
            lhs.cost == rhs.cost
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.fromNode)
        hasher.combine(self.toNode)
        hasher.combine(self.cost)
    }
}

class AStarNode {
    var position: IntPoint
    var parent: AStarNode?
    var edges: Set<AStarEdge>
    
    /// Estimated cost
    var f: Int {
        return self.g + self.h
    }
    /// Current best cost from start to here
    var g: Int
    
    /// Estimated remaining cost
    var h: Int
    
    init(position: IntPoint, edges: Set<AStarEdge> = []) {
        self.position = position
        self.parent = nil
        self.edges = edges
        self.g = 0
        self.h = 0
    }
}

extension AStarNode: Hashable, Equatable {
    static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.position)
    }
}

class IntAStar {
    var open = Set<AStarNode>()
    var closed = Set<AStarNode>()
    
    // Returns whether path to end was found (only valid if end exists).
    // TraversalMap = All permissable locations.
    @discardableResult
    func computeShortestPaths(startNode: AStarNode, end: AStarNode? = nil) -> [IntPoint]? {
        self.open.removeAll(keepingCapacity: true)
        self.closed.removeAll(keepingCapacity: true)

        
        startNode.g = 0
        startNode.h = 0
        
        self.open.insert(startNode)
        
        while !self.open.isEmpty {
            let current = self.open.min(by: {$0.f < $1.f})!
            self.open.remove(current)
            self.closed.insert(current)
            
            if let end = end {
                if end.position == current.position {
                    var currentPathNode: AStarNode? = current
                    var path = [current.position]
                    while currentPathNode != nil {
                        path.insert(currentPathNode!.position, at: 0)
                        currentPathNode = currentPathNode?.parent
                    }
                    return path
                }
            }
            
            for edge in current.edges {
                let potentialNode = edge.toNode
                guard !self.closed.contains(potentialNode) else { continue }
                potentialNode.g = current.g + edge.cost
                if let end = end {
                    potentialNode.h = potentialNode.position.manhattanDistance(to: end.position)
                } else {
                    potentialNode.h = 0
                }
                potentialNode.parent = current
                
                if let existingNode = self.open.first(where: {$0.position == potentialNode.position}) {
                    if potentialNode.g < existingNode.g {
                        existingNode.g = potentialNode.g
                        existingNode.parent = current
                    }
                } else {
                    self.open.insert(potentialNode)
                }
            }
        }
        return nil
    }
}
