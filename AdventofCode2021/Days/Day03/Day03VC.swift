//
//  Day03VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 03/12/2021.
//

import Foundation
import UIKit

fileprivate struct DiagnosticReport {
    private enum SimpleMode {
        case gamma
        case epsilon
        
        func newBit(hasMostZeroes: Bool) -> String {
            switch self {
            case .gamma: return hasMostZeroes ? "0" : "1"
            case .epsilon: return hasMostZeroes ? "1" : "0"
            }
        }
    }
    private enum ComplexMode {
        case oxygenGenerator
        case co2Scrubber
        
        func filterString(hasMostZeroes: Bool) -> String {
            switch self {
            case .oxygenGenerator: return hasMostZeroes ? "0" : "1"
            case .co2Scrubber: return hasMostZeroes ? "1" : "0"
            }
        }
    }
    
    let gammaRating: Int
    let epsilonRating: Int
    let oxygenGeneratorRating: Int
    let co2ScrubberRating: Int
    
    var powerConsumption: Int {
        return gammaRating * epsilonRating
    }
    
    var lifeSupportRating: Int {
        return oxygenGeneratorRating * co2ScrubberRating
    }
    
    init(input: [[String]]) {
        gammaRating = Self.getSimpleRating(from: input, mode: .gamma)
        epsilonRating = Self.getSimpleRating(from: input, mode: .epsilon)
        oxygenGeneratorRating = Self.getComplexRating(from: input, mode: .oxygenGenerator)
        co2ScrubberRating = Self.getComplexRating(from: input, mode: .co2Scrubber)
    }
    
    private static func getSimpleRating(from input: [[String]], mode: SimpleMode) -> Int {
        let stringLength = input.first?.count ?? 0
        let bitString = (0..<stringLength).map { index in
            let bitFrequency = getBitFrequency(in: input, at: index)
            let hasMostZeroes = (bitFrequency == .mostZeroes)
            return mode.newBit(hasMostZeroes: hasMostZeroes)
        }.joined(separator: "")
        
        return Int(bitString, radix: 2)!
    }
        
    private static func getComplexRating(from input: [[String]], mode: ComplexMode) -> Int {
        var currInput = input
        
        let stringLength = input.first?.count ?? 0
        for index in 0..<stringLength {
            guard currInput.count > 1 else { break }
            let bitFrequency = getBitFrequency(in: currInput, at: index)
            let hasMostZeroes = (bitFrequency == .mostZeroes)
            let filterString = mode.filterString(hasMostZeroes: hasMostZeroes)
            currInput = currInput.filter({$0[index] == filterString})
        }
        
        guard currInput.count == 1 else { fatalError("Should have only 1 valid input at this point!") }
        let bitString = currInput[0].joined(separator: "")
        return Int(bitString, radix: 2)!
    }
    
    private enum BitFrequency {
        case equal
        case mostOnes
        case mostZeroes
    }
    
    private static func getBitFrequency(in input: [[String]], at index: Int) -> BitFrequency {
        let numZeroBits = input.map({$0[index]}).filter({$0 == "0"}).count
        let numOneBits = input.count - numZeroBits
        
        if numZeroBits == numOneBits {
            return .equal
        }
        return numZeroBits > numOneBits ? .mostZeroes : .mostOnes
    }
}

class Day03VC: AoCVC, AdventDay {
    private var input: [[String]] = []
    private var diagnosticReport: DiagnosticReport!
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray().map({$0.convertToStringArray()})
    }
    
    func inputDidLoad() {
        diagnosticReport = DiagnosticReport(input: input)
    }
    
    func solvePart1() -> String {
        return "\(diagnosticReport.powerConsumption)"
    }
    
    func solvePart2() -> String {
        return "\(diagnosticReport.lifeSupportRating)"
    }
}

extension Day03VC {
    func doTests() {
        let input =
        """
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
        """.components(separatedBy: "\n").map({$0.convertToStringArray()})
        
        let diagnosticReport = DiagnosticReport(input: input)
        assert(diagnosticReport.gammaRating == 22)
        assert(diagnosticReport.epsilonRating == 9)
        assert(diagnosticReport.powerConsumption == 198)
        assert(diagnosticReport.oxygenGeneratorRating == 23)
        assert(diagnosticReport.co2ScrubberRating == 10)
        assert(diagnosticReport.lifeSupportRating == 230)
    }
}
