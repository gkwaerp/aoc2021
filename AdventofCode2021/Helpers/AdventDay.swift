//
//  AdventDay.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation
import UIKit

protocol AdventDay: UIViewController {
    func loadInput()
    func doPreSolutionWork()
    func doTests()
    func solvePart1() -> String
    func solvePart2() -> String
}

extension AdventDay {
    func loadInput() {
        print("No input today!")
    }
    
    func doPreSolutionWork() {
        print("Nothing to do before we can solve!")
    }
    
    func doTests() {
        print("No tests today!")
    }
    
    func solvePart1() -> String {
        return "Not implemented"
    }
    
    func solvePart2() -> String {
        return "Not implemented"
    }
}
