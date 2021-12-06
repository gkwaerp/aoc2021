//
//  Day06VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 06/12/2021.
//

import Foundation
import UIKit

class Day06VC: AoCVC, AdventDay {
    private class LFSimulator {
        /// (Days + InitialTimer) --> NumSpawns
        // IntPoint used since it conforms to Hashable
        static private var cache: [IntPoint: Int] = [:]
        private var lanternFishTimers: [Int]
        
        init(lanternFishTimers: [Int]) {
            self.lanternFishTimers = lanternFishTimers
        }
        
        func calculate(days: Int) -> Int {
            let spawned = lanternFishTimers.map({calc(days: days, initialTimer: $0)}).reduce(0, +)
            
            return spawned + lanternFishTimers.count
        }
        
        private func calc(days: Int, initialTimer: Int) -> Int {
            if let cachedValue = Self.cache[IntPoint(x: days, y: initialTimer)] {
                return cachedValue
            }
            
            var numSpawns = 0
            
            var remainingDays = days - initialTimer
            if remainingDays > 0 {
                numSpawns += 1
                numSpawns += calc(days: remainingDays, initialTimer: 9)
            }
            
            while remainingDays > 7 {
                remainingDays -= 7
                
                numSpawns += 1
                numSpawns += calc(days: remainingDays, initialTimer: 9)
            }
            
            Self.cache[IntPoint(x: days, y: initialTimer)] = numSpawns
            
            return numSpawns
        }
    }
    
    private var input: String!
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextString()
    }
    
    func solvePart1() -> String {
        let lanternFishTimers = input
            .components(separatedBy: ",")
            .map({Int($0)!})
        
        let simulator = LFSimulator(lanternFishTimers: lanternFishTimers)
        let result = simulator.calculate(days: 80)
        
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let lanternFishTimers = input
            .components(separatedBy: ",")
            .map({Int($0)!})
        
        let simulator = LFSimulator(lanternFishTimers: lanternFishTimers)
        let result = simulator.calculate(days: 256)
        
        return "\(result)"
    }
}

extension Day06VC {
    func doTests() {
        let input = "3,4,3,1,2"

        let lanternFishTimers = input
            .components(separatedBy: ",")
            .map({Int($0)!})

        let simulator = LFSimulator(lanternFishTimers: lanternFishTimers)
        let expected = [5, 6, 7, 9, 10, 10, 10, 10, 11, 12, 15, 17, 19, 20, 20, 21, 22, 26]
        (1...18).forEach({ day in
            let result = simulator.calculate(days: day)
            let expectedResult = expected[day - 1]
            assert(result == expectedResult)
        })

        let day80Result = simulator.calculate(days: 80)
        assert(day80Result == 5934)
        
        let day256Result = simulator.calculate(days: 256)
        assert(day256Result == 26984457539)
    }
}
