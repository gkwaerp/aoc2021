//
//  Day08VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 08/12/2021.
//

import Foundation
import UIKit

class Day08VC: AoCVC, AdventDay {
    private struct SignalPattern: Hashable {
        let pattern: Set<String>
        
        init(string: String) {
            pattern = Set(string.convertToStringArray())
        }
    }
    private struct Entry {
        let signalPatterns: [SignalPattern]
        let outputRaw: [SignalPattern]
        
        init(input: String) {
            let split = input.components(separatedBy: "|").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
            signalPatterns = split[0].components(separatedBy: " ").map({SignalPattern(string: $0)})
            outputRaw = split[1].components(separatedBy: " ").map({SignalPattern(string: $0)})
        }
        
        var easyDigitCount: Int {
            return outputRaw.filter { s in
                return s.pattern.count == 2 || s.pattern.count == 3 || s.pattern.count == 4 || s.pattern.count == 7
            }.count
        }
        
        func unscrambleOutput() -> Int {
            var currentUnmapped: [SignalPattern] = signalPatterns
            var numberToPattern: [Int: SignalPattern] = [
                1: currentUnmapped.filter({$0.pattern.count == 2}).first!,
                4: currentUnmapped.filter({$0.pattern.count == 4}).first!,
                7: currentUnmapped.filter({$0.pattern.count == 3}).first!,
                8: currentUnmapped.filter({$0.pattern.count == 7}).first!
            ]
            currentUnmapped.removeAll(where: {$0 == numberToPattern[1]})
            currentUnmapped.removeAll(where: {$0 == numberToPattern[4]})
            currentUnmapped.removeAll(where: {$0 == numberToPattern[7]})
            currentUnmapped.removeAll(where: {$0 == numberToPattern[8]})
            
            numberToPattern[6] = currentUnmapped.filter { s in
                guard s.pattern.count == 6 else { return false }
                let intersection = s.pattern.intersection(numberToPattern[1]!.pattern)
                return intersection.count == 1
            }.first!
            currentUnmapped.removeAll(where: {$0 == numberToPattern[6]})

            numberToPattern[5] = currentUnmapped.filter { s in
                guard s.pattern.count == 5 else { return false }
                let intersection = s.pattern.intersection(numberToPattern[6]!.pattern)
                return intersection.count == 5
            }.first!
            currentUnmapped.removeAll(where: {$0 == numberToPattern[5]})
            
            numberToPattern[3] = currentUnmapped.filter { s in
                guard s.pattern.count == 5 else { return false }
                let intersection = s.pattern.intersection(numberToPattern[1]!.pattern)
                return intersection.count == 2
            }.first!
            currentUnmapped.removeAll(where: {$0 == numberToPattern[3]})
            
            numberToPattern[2] = currentUnmapped.filter { s in
                return s.pattern.count == 5
            }.first!
            currentUnmapped.removeAll(where: {$0 == numberToPattern[2]})
            
            numberToPattern[9] = currentUnmapped.filter { s in
                guard s.pattern.count == 6 else { return false }
                let intersection = s.pattern.intersection(numberToPattern[4]!.pattern)
                return intersection.count == 4
            }.first!
            currentUnmapped.removeAll(where: {$0 == numberToPattern[9]})
            
            numberToPattern[0] = currentUnmapped.first!
            currentUnmapped.removeAll(where: {$0 == numberToPattern[0]})
            
            
            var patternToNumber: [SignalPattern: Int] = [:]
            numberToPattern.forEach { (number: Int, pattern: SignalPattern) in
                patternToNumber[pattern] = number
            }
            
            let outputString = outputRaw.map({"\(patternToNumber[$0]!)"}).joined()
            return Int(outputString)!
        }
    }
    
    private var input: [Entry] = []
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray().map({Entry(input: $0)})
    }
    
    func solvePart1() -> String {
        let result = countEasyDigits(in: input)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let result = sum(input)
        return "\(result)"
    }
    
    private func countEasyDigits(in entries: [Entry]) -> Int {
        return entries.map({$0.easyDigitCount}).reduce(0, +)
    }
    
    private func sum(_ entries: [Entry]) -> Int {
        return entries.map({$0.unscrambleOutput()}).reduce(0, +)
    }
}

extension Day08VC {
    func doTests() {
        let input =
        """
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
        """.components(separatedBy: .newlines)
        
        let entries = input.map({Entry(input: $0)})
        
        let easyCount = countEasyDigits(in: entries)
        assert(easyCount == 26)
        
        let summed = sum(entries)
        assert(summed == 61229)
    }
}
