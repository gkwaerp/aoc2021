//
//  Day02VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 02/12/2021.
//

import Foundation
import UIKit

class Day02VC: AoCVC, AdventDay {
    private struct Instruction {
        enum Direction: String {
            case forward
            case down
            case up
        }
        let units: Int
        let direction: Direction
        
        init(string: String) {
            let split = string.components(separatedBy: " ")
            direction = Direction(rawValue: split[0])!
            units = Int(split[1])!
        }
    }
    
    private struct Position {
        var depth: Int = 0
        var horizontal: Int = 0
        var aim: Int = 0
        
        var product: Int {
            return depth * horizontal
        }
        
        mutating func apply(instructions: [Instruction], usingAim: Bool) {
            instructions.forEach { instruction in
                switch instruction.direction {
                case .forward:
                    horizontal += instruction.units
                    if usingAim {
                        depth += aim * instruction.units
                    }
                case .up:
                    if usingAim {
                        aim -= instruction.units
                    } else {
                        depth -= instruction.units
                    }
                case .down:
                    if usingAim {
                        aim += instruction.units
                    } else {
                        depth += instruction.units
                    }
                }
            }
        }
    }

    private var input: [Instruction] = []
    
    func loadInput() {
        input = defaultInputFileString
            .loadAsTextStringArray()
            .map{Instruction(string: $0)}
    }
    
    func solvePart1() -> String {
        var position = Position()
        position.apply(instructions: input, usingAim: false)
        
        return "\(position.product)"
    }
    
    func solvePart2() -> String {
        var position = Position()
        position.apply(instructions: input, usingAim: true)
        
        return "\(position.product)"
    }
    
}

extension Day02VC {
    func doTests() {
        let input =
        """
        forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2
        """.components(separatedBy: "\n")
            .map({Instruction(string: $0)})
        
        var position = Position(depth: 0, horizontal: 0)
        position.apply(instructions: input, usingAim: false)
        
        assert(position.depth == 10)
        assert(position.horizontal == 15)
        assert(position.product == 150)
        
        var position2 = Position()
        position2.apply(instructions: input, usingAim: true)
        assert(position2.horizontal == 15)
        assert(position2.depth == 60)
        assert(position2.product == 900)
    }
}


