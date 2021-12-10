//
//  Day10VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 10/12/2021.
//

import Foundation
import UIKit

class Day10VC: AoCVC, AdventDay {
    private var input: [String] = []
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray()
    }
    
    func solvePart1() -> String {
        let result = getCorruptPointValue(for: input)
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let result = getAutoCompletePointValue(for: input)
        return "\(result)"
    }
    
    private func getCorruptPointValue(for lines: [String]) -> Int {
        let firstIllegalCharacters = lines.compactMap({$0.firstIllegalCharacter})
        return firstIllegalCharacters
            .map({$0.corruptPointValue})
            .reduce(0, +)
    }
    
    private func getAutoCompletePointValue(for lines: [String]) -> Int {
        var scores: [Int] = []
        
        for line in lines {
            guard !line.isCorrupt else { continue }
            let arrayed = line.convertToStringArray()
            var openingCharacters: [String] = []
            for c in arrayed {
                if c.isOpeningCharacter {
                    openingCharacters.append(c)
                } else if c.isClosingCharacter {
                    openingCharacters.removeLast()
                }
            }
            let score = openingCharacters.reversed().reduce(0, {$0 * 5 + $1.matchingClosingCharacter.autoCompletePointValue})
            scores.append(score)
        }
        
        let sorted = scores.sorted()
        return sorted[scores.count / 2]
    }
}

extension Day10VC {
    func doTests() {
        let input =
        """
        [({(<(())[]>[[{[]{<()<>>
        [(()[<>])]({[<{<<[]>>(
        {([(<{}[<>[]}>{[]{[(<()>
        (((({<>}<{<{<>}{[]{[]{}
        [[<[([]))<([[{}[[()]]]
        [{[{({}]{}}([{[{{{}}([]
        {<[[]]>}<{[{[{[]{()[[[]
        [<(<(<(<{}))><([]([]()
        <{([([[(<>()){}]>(<<{{
        <{([{{}}[<[[[<>{}]]]>[]]
        """.components(separatedBy: .newlines)
        
        let firstIllegalCharacters = input.compactMap({$0.firstIllegalCharacter})
        assert(firstIllegalCharacters.count == 5)
        
        let corruptPointValue = getCorruptPointValue(for: input)
        assert(corruptPointValue == 26397)
        
        let autoCompletePointValue = getAutoCompletePointValue(for: input)
        assert(autoCompletePointValue == 288957)
    }
}

fileprivate extension String {
    var isCorrupt: Bool {
        return firstIllegalCharacter != nil
    }
    
    var firstIllegalCharacter: String? {
        let arrayed = self.convertToStringArray()
        var openingCharacters: [String] = []
        for c in arrayed {
            if c.isOpeningCharacter {
                openingCharacters.append(c)
            } else if c.isClosingCharacter {
                guard c.matchingOpeningCharacter == openingCharacters.last else { return c }
                openingCharacters.removeLast()
            }
        }
        return nil
    }
    
    var isOpeningCharacter: Bool {
        return ["(", "[", "{", "<"].contains(self)
    }
    
    var isClosingCharacter: Bool {
        return [")", "]", "}", ">"].contains(self)
    }
    
    var matchingOpeningCharacter: String {
        switch self {
        case ")": return "("
        case "]": return "["
        case "}": return "{"
        case ">": return "<"
        default: fatalError()
        }
    }
    
    var matchingClosingCharacter: String {
        switch self {
        case "(": return ")"
        case "[": return "]"
        case "{": return "}"
        case "<": return ">"
        default: fatalError()
        }
    }
    
    var corruptPointValue: Int {
        switch self {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: fatalError()
        }
    }
    
    var autoCompletePointValue: Int {
        switch self {
        case ")": return 1
        case "]": return 2
        case "}": return 3
        case ">": return 4
        default: fatalError()
        }
    }
}
