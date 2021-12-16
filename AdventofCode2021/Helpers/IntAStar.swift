//
//  IntAStar.swift
//  AdventofCode2021
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
        hasher.combine(fromNode)
        hasher.combine(toNode)
        hasher.combine(cost)
    }
}

class AStarNode {
    var position: IntPoint
    var parent: AStarNode?
    var edges: Set<AStarEdge>
    
    /// Estimated cost
    var f: Int {
        return g + h
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
        hasher.combine(position)
    }
}

class IntAStar {
    var closed = Set<IntPoint>()
    
    // Returns whether path to end was found (only valid if end exists).
    // TraversalMap = All permissable locations.
    @discardableResult
    func computeShortestPaths(startNode: AStarNode, end: AStarNode? = nil) -> [IntPoint]? {
        var open: PriorityQueue<AStarNode> = .init(sort: { return $0.f < $1.f} )
        closed.removeAll(keepingCapacity: true)

        startNode.g = 0
        startNode.h = 0
        
        open.enqueue(startNode)
        
        while let current = open.dequeue() {
            closed.insert(current.position)
            
            if let end = end {
                if end.position == current.position {
                    var currentPathNode: AStarNode? = current
                    var path: [IntPoint] = []
                    while let n = currentPathNode {
                        path.insert(n.position, at: 0)
                        currentPathNode = n.parent
                    }
                    return path
                }
            }
            
            for edge in current.edges {
                let potentialNode = edge.toNode
                guard !closed.contains(potentialNode.position) else { continue }
                let g = current.g + edge.cost
                
                if let existingNodeIndex = open.index(of: potentialNode) {
                    let existingNode = open.element(at: existingNodeIndex)
                    if g < existingNode.g {
                        potentialNode.g = g
                        potentialNode.parent = current
                        open.changePriority(index: existingNodeIndex, value: potentialNode)
                    }
                    
                } else {
                    potentialNode.parent = current
                    potentialNode.g = g
                    potentialNode.h = end.map({ potentialNode.position.manhattanDistance(to: $0.position)} ) ?? 0
                    open.enqueue(potentialNode)
                }
            }
        }
        
        return nil
    }
}
