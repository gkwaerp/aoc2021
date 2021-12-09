//
//  Day09VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 09/12/2021.
//

import Foundation
import UIKit

class Day09VC: AoCVC, AdventDay {
    private var input: [String]!
    private var grid: IntGrid!
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray()
    }
    
    func inputDidLoad() {
        grid = createIntGridFromStringArray(input)
    }
    
    func solvePart1() -> String {
        let result = calculateRisk(at: getLowPoints(in: grid),
                                   in: grid)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let lowPoints = getLowPoints(in: grid)
        let basins = lowPoints.map({getBasin(for: $0, in: grid)})
        let result = getSizeProduct(for: basins, prefix: 3)
        
        return "\(result)"
    }
    
    private func createIntGridFromStringArray(_ array: [String]) -> IntGrid {
        let intValues = array.map { string in
            return string.map { char in
                return Int("\(char)")!
            }
        }
        
        return IntGrid(values: intValues)
    }
    
    private func getLowPoints(in grid: IntGrid) -> [IntPoint] {
        var lowPoints: [IntPoint] = []
        let offsets = IntPoint.cardinalOffsets
        
        grid.gridPoints.forEach { point in
            let value = grid.getValue(at: point)!

            let isLowest = offsets.compactMap { offset in
                let newPoint = point + offset
                return grid.getValue(at: newPoint)
            }.allSatisfy { $0 > value }
            
            if isLowest {
                lowPoints.append(point)
            }
        }
        
        return lowPoints
    }
    
    private typealias Basin = Set<IntPoint>
    // Assumes all basins are surrounded by 9's. Works for my input!
    private func getBasin(for startingPoint: IntPoint, in grid: IntGrid) -> Basin {
        guard let value = grid.getValue(at: startingPoint) else { return [] }
        guard value < 9 else { return [] }
        
        var basin: Basin = [startingPoint]
        var uncheckedPoints: Set<IntPoint> = Set(IntPoint.cardinalOffsets.map({startingPoint + $0}))
        var checkedPoints: Set<IntPoint> = []
        
        while !uncheckedPoints.isEmpty {
            let p = uncheckedPoints.removeFirst()
            checkedPoints.insert(p)
            guard let value2 = grid.getValue(at: p), value2 < 9 else { continue }
            basin.insert(p)
            IntPoint.cardinalOffsets.forEach { offset in
                let newPoint = p + offset
                if !checkedPoints.contains(newPoint) {
                    uncheckedPoints.insert(newPoint)
                }
            }
        }
        
        return basin
    }
    
    private func getSizeProduct(for basins: [Basin], prefix: Int) -> Int {
        return basins
            .sorted(by: {$0.count > $1.count})
            .prefix(prefix)
            .map({$0.count})
            .reduce(1, *)
    }
    
    private func calculateRisk(at points: [IntPoint], in grid: IntGrid) -> Int {
        return points.compactMap({grid.getValue(at: $0)})
            .map({$0 + 1})
            .reduce(0, +)
    }
}

extension Day09VC {
    func doTests() {
        let input =
        """
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
        """.components(separatedBy: .newlines)
        
        let expectedLowPoints: [IntPoint] = [
            .init(x: 1, y: 0),
            .init(x: 9, y: 0),
            .init(x: 2, y: 2),
            .init(x: 6, y: 4)
        ]
        
        let grid = createIntGridFromStringArray(input)
        let lowPoints = getLowPoints(in: grid)
        assert(Set(lowPoints) == Set(expectedLowPoints))
        
        let risk = calculateRisk(at: lowPoints, in: grid)
        assert(risk == 15)
        
        let basins = lowPoints.map({getBasin(for: $0, in: grid)})
        let productOfLargest = getSizeProduct(for: basins, prefix: 3)
        assert(productOfLargest == 1134)
    }
}
