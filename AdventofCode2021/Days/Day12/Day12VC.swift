//
//  Day12VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 12/12/2021.
//

import Foundation
import UIKit

class Day12VC: AoCVC, AdventDay {
    private class Cave: Hashable, Equatable {
        static func == (lhs: Day12VC.Cave, rhs: Day12VC.Cave) -> Bool {
            return lhs.name == rhs.name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
        
        private var visitCount = 0
        
        enum CaveType {
            case start
            case small
            case large
            case end
        }
        
        let name: String
        let caveType: CaveType
        
        init(_ name: String) {
            self.name = name
            if name == "start" {
                self.caveType = .start
            } else if name == "end" {
                self.caveType = .end
            } else if name == name.lowercased() {
                self.caveType = .small
            } else {
                self.caveType = .large
            }
        }
        
        enum VisitResult {
            case normal
            case usedReentry
            case clearedReentry
        }
        
        func visit() -> VisitResult {
            visitCount += 1
            return (caveType == .small && visitCount > 1) ? .usedReentry : .normal
        }
        
        func unvisit() -> VisitResult {
            visitCount -= 1
            return (caveType == .small && visitCount > 0) ? .clearedReentry : .normal
        }
        
        func canVisit(allowReentry: Bool, hasUsedReentry: Bool) -> Bool {
            switch caveType {
            case .start:
                return false
            case .small:
                switch visitCount {
                case 0:
                    return true
                case 1:
                    return allowReentry && !hasUsedReentry
                default:
                    return false
                }
            case .large:
                return true
            case .end:
                return true
            }
        }
    }
    
    private class CaveLayout {
        let nodes: Set<Cave>
        let adjacencyList: [Cave: Set<Cave>]
        
        init(_ input: [String]) {
            var nodes: Set<Cave> = []
            var adjacencyList: [Cave: Set<Cave>] = [:]
            
            for s in input {
                let split = s.split(separator: "-")
                
                let fromString = String(split[0])
                let toString = String(split[1])
                
                let from = nodes.first(where: {$0.name == fromString}) ?? Cave(fromString)
                let to = nodes.first(where: {$0.name == toString}) ?? Cave(toString)
                
                nodes.insert(from)
                nodes.insert(to)
                
                adjacencyList[from, default: []].insert(to)
                adjacencyList[to, default: []].insert(from)
            }
            
            self.nodes = nodes
            self.adjacencyList = adjacencyList
        }
        
        private var hasUsedReentry = false
        
        func countUniquePaths(allowReentry: Bool) -> Int {
            hasUsedReentry = false
            return computePaths(newNode: Cave("start"), allowReentry: allowReentry)
        }
        
        private func computePaths(newNode node: Cave, allowReentry: Bool) -> Int {
            guard node.caveType != .end else { return 1 }
            
            if node.visit() == .usedReentry {
                hasUsedReentry = true
            }
            
            let numPaths =  adjacencyList[node]!
                .filter({$0.canVisit(allowReentry: allowReentry, hasUsedReentry: hasUsedReentry)})
                .map({computePaths(newNode: $0, allowReentry: allowReentry)})
                .reduce(0, +)
            
            if node.unvisit() == .clearedReentry {
                hasUsedReentry = false
            }
            
            return numPaths
        }
    }
    
    private var input: [String] = []
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray()
    }
    
    func solvePart1() -> String {
        let caveLayout = CaveLayout(input)
        let result = caveLayout.countUniquePaths(allowReentry: false)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let caveLayout = CaveLayout(input)
        let result = caveLayout.countUniquePaths(allowReentry: true)
        return "\(result)"
    }
}

extension Day12VC {
    func doTests() {
        let input1 =
        """
        start-A
        start-b
        A-c
        A-b
        b-d
        A-end
        b-end
        """.components(separatedBy: .newlines)
        
        let layout1 = CaveLayout(input1)
        let count1 = layout1.countUniquePaths(allowReentry: false)
        assert(count1 == 10)
        
        let count2 = layout1.countUniquePaths(allowReentry: true)
        assert(count2 == 36)
    }
}
