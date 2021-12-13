//
//  Day13VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 13/12/2021.
//

import Foundation
import UIKit

class Day13VC: AoCVC, AdventDay {
    private class OrigamiFolder {
        struct FoldInstruction {
            enum FoldDirection {
                case vertical
                case horizontal
            }
            
            let foldDirection: FoldDirection
            let foldPoint: Int
            
            init(_ string: String) {
                let split = string.components(separatedBy: "=")
                foldDirection = split[0].contains("y") ? .vertical : .horizontal
                foldPoint = Int(split[1])!
            }
        }
        
        private var dots: Set<IntPoint>
        private var foldInstructions: [FoldInstruction]
        
        init(dots: [String], foldInstructions: [String]) {
            self.dots = Set(dots.map({ s in
                let split = s.components(separatedBy: ",")
                return IntPoint(x: Int(split[0])!,
                                y: Int(split[1])!)
            }))
            self.foldInstructions = foldInstructions.map({FoldInstruction($0)})
        }
        
        func fold() {
            while !foldInstructions.isEmpty {
                foldOnce()
            }
        }
        
        func foldOnce() {
            let instruction = foldInstructions.removeFirst()
            switch instruction.foldDirection {
            case .vertical:
                dots.filter({$0.y > instruction.foldPoint})
                    .forEach { pos in
                        let newY = 2 * instruction.foldPoint - pos.y
                        dots.insert(IntPoint(x: pos.x, y: newY))
                        dots.remove(pos)
                    }
            case .horizontal:
                dots.filter({$0.x > instruction.foldPoint})
                    .forEach { pos in
                        let newX = 2 * instruction.foldPoint - pos.x
                        dots.insert(IntPoint(x: newX, y: pos.y))
                        dots.remove(pos)
                    }
            }
        }
        
        func dotCount() -> Int {
            return dots.count
        }
        
        func asText() -> String {
            let maxX = dots.max(by: {$0.x < $1.x})!.x + 1
            let maxY = dots.max(by: {$0.y < $1.y})!.y + 1
            let gridSize = IntPoint(x: maxX, y: maxY)
            let grid = StringGrid(size: gridSize, fillWith: ".")
            dots.forEach { point in
                grid.setValue(at: point, to: "#")
            }
            
            return "\n\(grid.asText(printClosure: StringGrid.defaultPrintClosure()))"
        }
    }
    
    private var input: [String] = []
    
    func loadInput() {
        input = defaultInputFileString
            .loadAsTextString()
            .components(separatedBy: "\n\n")
    }
    
    func solvePart1() -> String {
        let origamiFolder = OrigamiFolder(dots: input[0].components(separatedBy: .newlines),
                                          foldInstructions: input[1].components(separatedBy: .newlines))
        origamiFolder.foldOnce()
        let dotCount = origamiFolder.dotCount()
        return "\(dotCount)"
    }
    
    func solvePart2() -> String {
        let origamiFolder = OrigamiFolder(dots: input[0].components(separatedBy: .newlines),
                                          foldInstructions: input[1].components(separatedBy: .newlines))
        
        origamiFolder.fold()
        
        return origamiFolder.asText()
    }
}

extension Day13VC {
    func doTests() {
        let input =
        """
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
        """.components(separatedBy: "\n\n")
        
        let origamiFolder = OrigamiFolder(dots: input[0].components(separatedBy: .newlines),
                                          foldInstructions: input[1].components(separatedBy: .newlines))
        origamiFolder.foldOnce()
        let dotCount = origamiFolder.dotCount()
        assert(dotCount == 17)
        
        origamiFolder.fold()
        let expectedOutput =
        """
        #####
        #...#
        #...#
        #...#
        #####
        """
        
        assert(origamiFolder.asText().trimmingCharacters(in: .whitespacesAndNewlines) == expectedOutput)
    }
}
