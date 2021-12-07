//
//  Day07VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 07/12/2021.
//

import Foundation
import UIKit

class Day07VC: AoCVC, AdventDay {
    private enum CrabFuelMode {
        case constant
        case increasing
        
        func getCostToAlign(at pos: Int, from startingPositions: [Int]) -> Int {
            switch self {
            case .constant:
                let costs = startingPositions.map( {abs($0 - pos) })
                return costs.reduce(0, +)
            case .increasing:
                let costs = startingPositions.map { startingPos -> Int in
                    let delta = abs(startingPos - pos)
                    return (delta * (delta + 1)) / 2
                }
                return costs.reduce(0, +)
            }
        }
    }

    private var input: [Int] = []
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextString()
            .components(separatedBy: ",")
            .map({Int($0)!})
    }
    
    func solvePart1() -> String {
        let result = getLeastFuelToAlign(from: input, crabFuelMode: .constant)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let result = getLeastFuelToAlign(from: input, crabFuelMode: .increasing)
        return "\(result)"
    }
    
    private func getLeastFuelToAlign(from startingPositions: [Int], crabFuelMode: CrabFuelMode) -> Int {
        let positionsToCheck = (startingPositions.min()!...startingPositions.max()!)
        let fuelCosts = positionsToCheck.map({crabFuelMode.getCostToAlign(at: $0, from: startingPositions)})
        return fuelCosts.min()!
    }
}

extension Day07VC {
    func doTests() {
        let input = "16,1,2,0,4,2,7,1,2,14"
            .components(separatedBy: ",")
            .map({Int($0)!})
        
        let leastFuelConstant = getLeastFuelToAlign(from: input, crabFuelMode: .constant)
        assert(leastFuelConstant == 37)
        
        let leastFuelIncreasing = getLeastFuelToAlign(from: input, crabFuelMode: .increasing)
        assert(leastFuelIncreasing == 168)
    }
}
