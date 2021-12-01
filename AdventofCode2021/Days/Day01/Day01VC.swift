//
//  Day01VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 01/12/2021.
//

import Foundation
import UIKit

class Day01VC: AoCVC, AdventDay {
    private var input: [Int] = []
    
    func loadInput() {
        input = defaultInputFileString
            .loadAsTextStringArray()
            .map({Int($0)!})
    }
    
    func solvePart1() -> String {
        let result = countIncreases(array: input, offset: 1)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let result = countIncreases(array: input, offset: 3)
        return "\(result)"
    }
    
    private func countIncreases(array: [Int], offset: Int) -> Int {
        return array.enumerated().reduce(into: 0) { partialResult, iterator in
            guard iterator.offset + offset < array.count,
                  array[iterator.offset + offset] > iterator.element else { return }
            partialResult += 1
        }
    }
}

extension Day01VC {
    func doTests() {
        let input =
        """
        199
        200
        208
        210
        200
        207
        240
        269
        260
        263
        """.components(separatedBy: "\n")
            .map({Int($0)!})
        
        let result = countIncreases(array: input, offset: 1)
        assert(result == 7)
        
        let result2 = countIncreases(array: input, offset: 3)
        assert(result2 == 5)
    }
}
