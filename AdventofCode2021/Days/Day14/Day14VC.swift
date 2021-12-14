//
//  Day14VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 14/12/2021.
//

import Foundation
import UIKit

class Day14VC: AoCVC, AdventDay {
    class PolymerManager {
        private let polymerTemplate: String
        
        /// Subpolymer pair --> Insertion character
        private typealias RulesDictionary = [String: String]
        private var rulesDictionary: RulesDictionary = [:]
        
        /// Subpolymer pair --> Count
        private typealias PairDictionary = [String: Int]
        private var pairDictionary: PairDictionary = [:]
        private var characterDictionary: [String: Int] = [:]
        
        init(_ input: [String]) {
            self.polymerTemplate = input[0]
            
            input[1].components(separatedBy: .newlines).forEach { string in
                let split = string.components(separatedBy: " -> ")
                rulesDictionary[split[0]] = split[1]
            }
            
            let polymerLength = polymerTemplate.count
            for i in (0..<polymerLength - 1) {
                let startIndex = polymerTemplate.index(polymerTemplate.startIndex, offsetBy: i)
                let endIndex = polymerTemplate.index(startIndex, offsetBy: 1)
                let substring = polymerTemplate[startIndex...endIndex]
                
                pairDictionary[String(substring), default: 0] += 1
            }
            
            polymerTemplate.forEach({ characterDictionary["\($0)", default: 0] += 1 })
        }
        
        func performSteps(_ numSteps: Int) {
            for _ in 0..<numSteps {
                step()
            }
        }
        
        private func step() {
            var newPairDictionary: PairDictionary = [:]
            
            pairDictionary.forEach { (key, value) in
                if let charToInsert = rulesDictionary[key] {
                    characterDictionary[charToInsert, default: 0] += value
                    newPairDictionary["\(key.first!)\(charToInsert)", default: 0] += value
                    newPairDictionary["\(charToInsert)\(key.last!)", default: 0] += value
                } else {
                    newPairDictionary[key] = value
                }
            }
            
            pairDictionary = newPairDictionary
        }
        
        func getBiggestQuantityDifference() -> Int {
            let sorted = characterDictionary.sorted(by: {$0.value < $1.value})
            return abs(sorted.first!.value - sorted.last!.value)
        }
    }
    
    private var input: [String] = []
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextString().components(separatedBy: "\n\n")
    }
    
    func solvePart1() -> String {
        let polymerManager = PolymerManager(input)
        polymerManager.performSteps(10)
        let result = polymerManager.getBiggestQuantityDifference()
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let polymerManager = PolymerManager(input)
        polymerManager.performSteps(40)
        let result = polymerManager.getBiggestQuantityDifference()
        return "\(result)"
    }
}

extension Day14VC {
    func doTests() {
        let input =
        """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """.components(separatedBy: "\n\n")
        
        let polymerManager = PolymerManager(input)
        assert(polymerManager.getBiggestQuantityDifference() == 1)
        
        polymerManager.performSteps(10)
        assert(polymerManager.getBiggestQuantityDifference() == 1588)
        
        polymerManager.performSteps(30)
        assert(polymerManager.getBiggestQuantityDifference() == 2188189693529)
    }
}
