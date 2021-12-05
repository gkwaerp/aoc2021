//
//  Day04VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 04/12/2021.
//

import Foundation
import UIKit

class Day04VC: AoCVC, AdventDay {
    private class BingoBoard {
        private class BingoCell {
            let value: Int
            var isMarked: Bool
            
            init(value: Int) {
                self.value = value
                self.isMarked = false
            }
        }
        
        private let grid: Grid<BingoCell>
        var hasWon: Bool = false
        
        init(input: String) {
            let bingoCells = input
                .components(separatedBy: "\n")
                .map { line in
                    line.components(separatedBy: " ")
                        .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        .filter({ !$0.isEmpty })
                        .map({ Int($0)! })
                        .map{ BingoCell(value: $0) }
                }
            
            grid = Grid(values: bingoCells)
        }
        
        private var unmarkedNumbers: [Int] {
            return grid.values
                .filter({!$0.isMarked})
                .map({$0.value})
        }
        
        var unmarkedSum: Int {
            return unmarkedNumbers.reduce(0, +)
        }
        
        private lazy var rows: [[BingoCell]] = {
            return (0..<grid.height).map { y in
                (0..<grid.width).compactMap { x in
                    return grid.getValue(at: IntPoint(x: x, y: y))
                }
            }
        }()
 
        private lazy var columns: [[BingoCell]] = {
            return (0..<grid.width).map { x in
                (0..<grid.height).compactMap { y in
                    return grid.getValue(at: IntPoint(x: x, y: y))
                }
            }
        }()
        
        func mark(number: Int) {
            guard let bingoCell = grid.values.first(where: { $0.value == number }) else { return }
            
            bingoCell.isMarked = true
            checkForWinState()
        }
        
        private func checkForWinState() {
            for line in (rows + columns) {
                if line.allSatisfy({ $0.isMarked }) {
                    hasWon = true
                    return
                }
            }
        }
    }
    
    private struct Win {
        let boardIndex: Int
        let unmarkedSum: Int
        let lastDrawnNumber: Int
        
        var winningScore: Int {
            return unmarkedSum * lastDrawnNumber
        }
    }
    
    private class BingoManager {
        enum GamePurpose {
            case win
            case survive
        }
        
        private var drawnNumberSequence: [Int]
        private let boards: [BingoBoard]
        
        private var winHistory: [Win] = []
        
        init(input: [String]) {
            drawnNumberSequence = input[0]
                .components(separatedBy: ",")
                .map({ Int($0)! })
            boards = input[1...].map({ BingoBoard(input: $0) })
        }
        
        func play() {
            while !drawnNumberSequence.isEmpty {
                let drawnNumber = drawnNumberSequence.removeFirst()
                updateBoards(with: drawnNumber)
            }
        }
        
        func getBestBoard(for purpose: GamePurpose) -> Win {
            switch purpose {
            case .win:
                return winHistory.first!
            case .survive:
                return winHistory.last!
            }
        }
        
        private func updateBoards(with number: Int) {
            boards.enumerated().forEach { (index, board) in
                guard !board.hasWon else { return }
                board.mark(number: number)
                if board.hasWon {
                    winHistory.append(Win(boardIndex: index,
                                          unmarkedSum: board.unmarkedSum,
                                          lastDrawnNumber: number))
                }
            }
        }
    }
    
    private var input: [String] = []
    private var bingoManager: BingoManager!
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextStringArray(separator: "\n\n")
    }
    
    func inputDidLoad() {
        bingoManager = BingoManager(input: input)
    }
    
    func solvePart1() -> String {
        bingoManager.play()
        let board = bingoManager.getBestBoard(for: .win)
        return "\(board.winningScore)"
    }
    
    func solvePart2() -> String {
        bingoManager.play()
        let board = bingoManager.getBestBoard(for: .survive)
        return "\(board.winningScore)"
    }
}

extension Day04VC {
    func doTests() {
        let input =
        """
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11  0
         8  2 23  4 24
        21  9 14 16  7
         6 10  3 18  5
         1 12 20 15 19

         3 15  0  2 22
         9 18 13 17  5
        19  8  7 25 23
        20 11 10 24  4
        14 21 16 12  6

        14 21 17 24  4
        10 16 15  9 19
        18  8 23 26 20
        22 11 13  6  5
         2  0 12  3  7
        """.components(separatedBy: "\n\n")
        
        let bingoManager = BingoManager(input: input)
        bingoManager.play()
        let winBoard = bingoManager.getBestBoard(for: .win)
        assert(winBoard.boardIndex == 2)
        assert(winBoard.unmarkedSum == 188)
        assert(winBoard.lastDrawnNumber == 24)
        assert(winBoard.winningScore == 4512)
        
        let surviveBoard = bingoManager.getBestBoard(for: .survive)
        assert(surviveBoard.boardIndex == 1)
        assert(surviveBoard.unmarkedSum == 148)
        assert(surviveBoard.lastDrawnNumber == 13)
        assert(surviveBoard.winningScore == 1924)
    }
}
