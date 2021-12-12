//
//  Day12VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 12/12/2021.
//

import Foundation
import UIKit

class Day12VC: AoCVC, AdventDay {
    private class CaveLayout {
        struct VisitHistory {
            let allowReentry: Bool
            
            private var history: [String: Int] = [:]
            private var hasReentered: Bool = false
            
            init(allowReentry: Bool) {
                self.allowReentry = allowReentry
            }
            
            mutating func visit(node: String) {
                history[node, default: 0] += 1
                if node.lowercased() == node && node != "start" {
                    if history[node]! == 2 {
                        hasReentered = true
                    }
                }
            }
            
            func canVisit(node: String) -> Bool {
                if node == "start" {
                    return false
                }
                
                if node.uppercased() == node {
                    return true
                }
                
                let maxVisitCountSmallCaves = (allowReentry && !hasReentered) ? 2 : 1
                return history[node, default: 0] < maxVisitCountSmallCaves
            }
        }
        
        let nodes: Set<String>
        let adjacencyList: [String: Set<String>]
        
        init(_ input: [String]) {
            var nodes: Set<String> = []
            var adjacencyList: [String: Set<String>] = [:]
            
            for s in input {
                let split = s.split(separator: "-")
                
                let from = String(split[0])
                let to = String(split[1])
                nodes.insert(from)
                nodes.insert(to)
                
                adjacencyList[from, default: []].insert(to)
                adjacencyList[to, default: []].insert(from)
            }
            
            self.nodes = nodes
            self.adjacencyList = adjacencyList
        }
        
        
        
        func countUniquePaths(allowReentry: Bool) -> Int {
            return computePaths(pathSoFar: [], newNode: "start", with: VisitHistory(allowReentry: allowReentry))
        }
        
        private func computePaths(pathSoFar: Set<String>, newNode node: String, with history: VisitHistory) -> Int {
            var mutableHistory = history
            mutableHistory.visit(node: node)
            guard node != "end" else { return 1 }
            
            let updatedPath = pathSoFar.union([node])
            let nodesToSearch = adjacencyList[node]!
                .filter({mutableHistory.canVisit(node: $0)})
            return nodesToSearch.map({computePaths(pathSoFar: updatedPath, newNode: $0, with: mutableHistory)})
                .reduce(0, +)
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
