//
//  Day05VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 05/12/2021.
//

import Foundation
import UIKit

class Day05VC: AoCVC, AdventDay {
    private struct LineSegment {
        let from: IntPoint
        let to: IntPoint
        
        private var isDiagonal: Bool {
            let isHorizontal = from.x == to.x
            let isVertical = from.y == to.y
            
            return !isHorizontal && !isVertical
        }
        
        init(input: String) {
            let split = input
                .components(separatedBy: "->")
                .map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
            
            let fromCoordinates = split[0].components(separatedBy: ",")
            let toCoordinates = split[1].components(separatedBy: ",")
            
            from = IntPoint(x: Int(fromCoordinates[0])!,
                            y: Int(fromCoordinates[1])!)
            
            to = IntPoint(x: Int(toCoordinates[0])!,
                          y: Int(toCoordinates[1])!)
        }
        
        func allPoints(includeDiagonal: Bool) -> [IntPoint] {
            guard includeDiagonal || !isDiagonal else { return [] }
            let delta = to - from
            let numSteps = max(abs(delta.x),
                               abs(delta.y))
            
            let step = delta.divided(by: numSteps)
            return (0...numSteps).map { from + step.scaled(by: $0) }
        }
    }
    
    private struct VentMap {
        private let lineSegments: [LineSegment]
        
        init(input: [String]) {
            lineSegments = input.map({LineSegment(input: $0)})
        }
        
        func countOverlappingVents(includeDiagonal: Bool) -> Int {
            var hashMap: [IntPoint: Int] = [:] // Position -> Number of vents
            
            allPoints(includeDiagonal: includeDiagonal).forEach { point in
                hashMap[point, default: 0] += 1
            }
            
            return hashMap.values.filter({$0 > 1}).count
        }
        
        private func allPoints(includeDiagonal: Bool) -> [IntPoint] {
            return Array(lineSegments
                            .map({$0.allPoints(includeDiagonal: includeDiagonal)})
                            .joined())
        }
    }
    
    private var input: [String] = []
    private var ventMap: VentMap!
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray()
    }
    
    func inputDidLoad() {
        ventMap = VentMap(input: input)
    }
    
    func solvePart1() -> String {
        let numOverLapping = ventMap.countOverlappingVents(includeDiagonal: false)
        return "\(numOverLapping)"
    }
    
    func solvePart2() -> String {
        let numOverLapping = ventMap.countOverlappingVents(includeDiagonal: true)
        return "\(numOverLapping)"
    }
}

extension Day05VC {
    func doTests() {
        let input =
        """
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
        """.components(separatedBy: .newlines)
        
        let lineSegments = input.map({LineSegment(input: $0)})
        assert(lineSegments[0].from == IntPoint(x: 0, y: 9))
        assert(lineSegments[0].to == IntPoint(x: 5, y: 9))
        
        let pointsThatShouldExist: [IntPoint] = [
            IntPoint(x: 0, y: 9),
            IntPoint(x: 1, y: 9),
            IntPoint(x: 2, y: 9),
            IntPoint(x: 3, y: 9),
            IntPoint(x: 4, y: 9),
            IntPoint(x: 5, y: 9)
        ]
        
        let allNonDiagonalPoints = lineSegments[0].allPoints(includeDiagonal: false)
        assert(allNonDiagonalPoints.count == pointsThatShouldExist.count)
        
        pointsThatShouldExist.forEach({assert(allNonDiagonalPoints.contains($0))})
        let ventMap = VentMap(input: input)
        let overlappingCount = ventMap.countOverlappingVents(includeDiagonal: false)
        assert(overlappingCount == 5)
        
        let overlappingWithDiagonal = ventMap.countOverlappingVents(includeDiagonal: true)
        assert(overlappingWithDiagonal == 12)
    }
}
