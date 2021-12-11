//
//  Day11VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 11/12/2021.
//

import Foundation
import UIKit

class Day11VC: AoCVC, AdventDay {
    private typealias OctopusGrid = Grid<Octopus>
    private class Octopus {
        var energyLevel: Int
        var hasFlashedThisStep: Bool
        
        init(_ string: String) {
            energyLevel = Int(string)!
            hasFlashedThisStep = false
        }
        
        /// Result = didFlash, boost neighbors
        func step() -> Bool {
            guard !hasFlashedThisStep else { return false }
            energyLevel += 1
            energyLevel %= 10
            hasFlashedThisStep = energyLevel == 0
            return hasFlashedThisStep
        }
    }
    
    private class OctopusManager {
        private var grid: OctopusGrid
        private var numFlashes: Int
        
        init(grid: OctopusGrid) {
            self.grid = grid
            self.numFlashes = 0
        }
        
        func getNumFlashes(after steps: Int) -> Int {
            var numFlashes = 0
            for _ in 0..<steps {
                numFlashes += step()
            }
            
            return numFlashes
        }
        
        func getFirstSynchronousStep() -> Int {
            var stepIndex = 0
            
            while true {
                stepIndex += 1
                let numFlashes = step()
                if numFlashes == grid.values.count {
                    break
                }
            }
            
            return stepIndex
        }
        
        private func step() -> Int {
            for octopus in grid.values {
                octopus.hasFlashedThisStep = false
            }
            
            let offsets = IntPoint.allDirectionOffsets
            var pointsToCheck = grid.gridPoints
            while !pointsToCheck.isEmpty {
                let point = pointsToCheck.removeFirst()
                guard let octopus = grid.getValue(at: point) else { continue }
                let flashed = octopus.step()
                if flashed {
                    pointsToCheck.append(contentsOf: offsets.map{$0 + point})
                }
            }
            
            return grid.values.filter({$0.hasFlashedThisStep}).count
        }
    }

    private var input: [String] = []
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray()
    }
    
    func solvePart1() -> String {
        let manager = createOctopusManager(from: input)
        let result = manager.getNumFlashes(after: 100)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let manager = createOctopusManager(from: input)
        let result = manager.getFirstSynchronousStep()
        return "\(result)"
    }
    
    private func createOctopusManager(from stringArray: [String]) -> OctopusManager {
        let octopodes = Array(
            stringArray.map({ s in
                return s.convertToStringArray()
                    .map({Octopus($0)})
            }).joined()
        )
        
        let height = stringArray.count
        let width = stringArray[0].count
        
        let grid = OctopusGrid(size: IntPoint(x: width, y: height), values: octopodes)
        
        return OctopusManager(grid: grid)
    }
}

extension Day11VC {
    func doTests() {
        let input1 =
        """
        11111
        19991
        19191
        19991
        11111
        """.components(separatedBy: .newlines)
        
        let manager1 = createOctopusManager(from: input1)
        let numFlashes1 = manager1.getNumFlashes(after: 1)
        assert(numFlashes1 == 9)
        
        
        let input2 =
        """
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """.components(separatedBy: .newlines)
        
        let expectedFlashes: [IntPoint] = [.init(x: 10, y: 204),
                                           .init(x: 100, y: 1656)]
        
        for expectation in expectedFlashes {
            let manager2 = createOctopusManager(from: input2)
            let numFlashes2 = manager2.getNumFlashes(after: expectation.x)
            assert(numFlashes2 == expectation.y)
        }
        
        let manager2 = createOctopusManager(from: input2)
        let firstSynchronousStep = manager2.getFirstSynchronousStep()
        assert(firstSynchronousStep == 195)
    }
}
