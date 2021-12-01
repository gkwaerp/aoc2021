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
        let result = countIncreases(array: input, windowSize: 1)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let result = countIncreases(array: input, windowSize: 3)
        return "\(result)"
    }
    
    private func countIncreases(array: [Int], windowSize: Int) -> Int {
        let arrayToUse = convertToSlidingWindow(array: array, size: windowSize)
        
        var numIncreases = 0
        var prevValue: Int? = nil
        arrayToUse.forEach { value in
            if let prevValue = prevValue {
                if value > prevValue {
                    numIncreases += 1
                }
            }
            prevValue = value
        }
        
        return numIncreases
    }
    
    private func convertToSlidingWindow(array: [Int], size: Int) -> [Int] {
        guard size > 1 else { return array }
        var newArray: [Int] = []
        
        for i in 0..<array.count {
            let lastIndex = i + size - 1
            guard (lastIndex) < array.count else { break }
            let newValue = array[i...lastIndex].reduce(0, +)
            newArray.append(newValue)
        }
        
        return newArray
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
        
        let result = countIncreases(array: input, windowSize: 1)
        assert(result == 7)
        
        let result2 = countIncreases(array: input, windowSize: 3)
        assert(result2 == 5)
    }
}
