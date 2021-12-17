//
//  Day17VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 17/12/2021.
//

import Foundation
import UIKit

class Day17VC: AoCVC, AdventDay {
    class TargetArea {
        let xRange: ClosedRange<Int>
        let yRange: ClosedRange<Int>
        
        func isXInside(_ x: Int) -> Bool {
            return xRange.contains(x)
        }
        
        func isYInside(_ y: Int) -> Bool {
            return yRange.contains(y)
        }
        
        func isPointInsize(_ p: IntPoint) -> Bool {
            return isYInside(p.y) && isXInside(p.x)
        }
        
        init(input: String) {
            let coordinates = input.components(separatedBy: ": ")[1].components(separatedBy: ", ")
            let xCoords = coordinates[0].replacingOccurrences(of: "x=", with: "").components(separatedBy: "..").map({Int($0)!})
            let minX = min(xCoords[0], xCoords[1])
            let maxX = max(xCoords[0], xCoords[1])
            
            let yCoords = coordinates[1].replacingOccurrences(of: "y=", with: "").components(separatedBy: "..").map({Int($0)!})
            let minY = min(yCoords[0], yCoords[1])
            let maxY = max(yCoords[0], yCoords[1])
            
            xRange = minX...maxX
            yRange = minY...maxY
        }
    }
    
    private var input = ""
    private var targetArea: TargetArea!
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextString()
    }
    
    func inputDidLoad() {
        targetArea = TargetArea(input: input)
    }
    
    func solvePart1() -> String {
        let result = getHighestPointWhileHitting(targetArea)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let result = getNumInitialVelocitiesHitting(targetArea: targetArea)
        return "\(result)"
    }
    
    private func getHighestYVelocityHitting(_ targetArea: TargetArea) -> Int {
        return abs(targetArea.yRange.lowerBound + 1)
    }
    
    private func getHighestPointWhileHitting(_ targetArea: TargetArea) -> Int {
        let highestYVelocity = getHighestYVelocityHitting(targetArea)
        let highestPoint = (highestYVelocity * (highestYVelocity + 1)) / 2
        return highestPoint
    }
    
    private func getNumInitialVelocitiesHitting(targetArea: TargetArea) -> Int {
        
        let highestYVelocity = getHighestYVelocityHitting(targetArea)
    
        var potentialYs: Set<Int> = []
        for i in targetArea.yRange.lowerBound...highestYVelocity {
            var currY = 0
            var speed = i
            while currY >= targetArea.yRange.lowerBound {
                currY += speed
                speed -= 1
                if targetArea.isYInside(currY) {
                    potentialYs.insert(i)
                    break
                }
            }
        }
        
        var potentialXs: Set<Int> = []
        let highestXVelocity = targetArea.xRange.upperBound
        for i in 0...highestXVelocity {
            var currX = 0
            var speed = i
            while speed > 0 && currX <= targetArea.xRange.upperBound {
                currX += speed
                if speed > 0 {
                    speed -= 1
                }
                if targetArea.isXInside(currX) {
                    potentialXs.insert(i)
                    break
                }
            }
        }
        
        var count = 0
        for y in potentialYs {
            for x in potentialXs {
                var currPos = IntPoint(x: 0, y: 0)
                let speed = IntPoint(x: x, y: y)
                
                while currPos.x <= targetArea.xRange.upperBound && currPos.y >= targetArea.yRange.lowerBound {
                    currPos += speed
                    if speed.x > 0 {
                        speed.x -= 1
                    }
                    speed.y -= 1
                    
                    if targetArea.isPointInsize(currPos) {
                        count += 1
                        break
                    }
                }
            }
        }
        
        return count
    }
}

extension Day17VC {
    func doTests() {
        let input = "target area: x=20..30, y=-10..-5"
        let targetArea = TargetArea(input: input)
        let highestPoint = getHighestPointWhileHitting(targetArea)
        assert(highestPoint == 45)
        
        let numPossible = getNumInitialVelocitiesHitting(targetArea: targetArea)
        assert(numPossible == 112)
    }
}
