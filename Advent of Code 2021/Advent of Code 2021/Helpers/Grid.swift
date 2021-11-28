//
//  Grid.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation

class Grid {
    typealias GridValue = String
    typealias PrintBlock = (GridValue) -> (String?)
    var size: IntPoint
    var values: [GridValue]
    
    var width: Int {
        return self.size.x
    }
    var height: Int {
        return self.size.y
    }
    
    lazy var gridPoints: [IntPoint] = {
        self.size.gridPoints
    }()
    
    convenience init(size: IntPoint, fillWith value: GridValue) {
        let values: [GridValue] = Array(repeating: value, count: size.x * size.y)
        self.init(size: size, values: values)
    }
    
    convenience init(grid: Grid) {
        self.init(size: grid.size, values: grid.values)
    }
    
    /// Each element in the array corresponds to 1 row
    convenience init(stringArray: [String]) {
        var values: [Grid.GridValue] = []
        for line in stringArray {
            for char in line {
                values.append(String(char))
            }
        }
        let size = IntPoint(x: stringArray.first!.count, y: stringArray.count)
        self.init(size: size, values: values)
    }
    
    init(size: IntPoint, values: [GridValue]) {
        guard size.x > 0, size.y > 0 else { fatalError("Invalid grid, size must be non-negative in both axes.") }
        guard size.x * size.y == values.count else { fatalError("Invalid grid, values doesn't match size." ) }
        self.size = size
        self.values = values
    }
    
    func updateValues(_ newValues: [GridValue]) {
        guard newValues.count == self.values.count else { fatalError("Can't change size of grid after creation!") }
        self.values = newValues
    }
    
    func getIndex(for position: IntPoint) -> Int? {
        guard position.x < self.width, position.x >= 0 else { return nil }
        guard position.y < self.height, position.y >= 0 else { return nil }
        return position.y * self.width + position.x
    }
    
    func getValue(at position: IntPoint) -> GridValue? {
        guard let index = self.getIndex(for: position) else { return nil }
        return self.values[index]
    }
    
    func setValue(at position: IntPoint, to value: String) {
        guard let index = self.getIndex(for: position) else { return }
        self.values[index] = value
    }
    
    func getValues(offset from: IntPoint, offsets: [IntPoint]) -> [GridValue] {
        return offsets.compactMap({return self.getValue(at: from + $0)})
    }
    
    func getValues(matching filter: (Grid.GridValue) -> (Bool)) -> [Grid.GridValue] {
        return self.values.filter(filter)
    }
    
    private static var rawPrintClosure: PrintBlock = { (value) in
        return value
    }

    func asText(printClosure: PrintBlock = Grid.rawPrintClosure) -> String {
        var finalText = "\n"
        for y in 0..<self.height {
            for x in 0..<self.width {
                if let value = self.getValue(at: IntPoint(x: x, y: y)),
                    let outputString = printClosure(value) {
                    finalText.append(outputString)
                }                }
            finalText.append("\n")
        }
        return finalText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    typealias WalkableBlock = (GridValue) -> (Bool)
    
    private static var defaultWalkableBlock: WalkableBlock = { (gridValue) in
        switch gridValue {
        case "#":
            return false
        default:
            return true
        }
    }
    
    func createAStarNodes(walkableBlock isWalkable: WalkableBlock = Grid.defaultWalkableBlock,
                          allowedDirections: [Direction] = Direction.allCases,
                          directionCosts: [Direction: Int] = [:],
                          defaultCost: Int = 1) -> Set<AStarNode> {
        var nodes = Set<AStarNode>()
        for point in self.gridPoints {
            guard let gridValue = self.getValue(at: point) else { continue }
            if isWalkable(gridValue) {
                nodes.insert(AStarNode(position: point))
            }
        }
        
        for node in nodes {
            for direction in allowedDirections {
                let newPosition = node.position + direction.movementVector
                guard let newValue = self.getValue(at: newPosition), isWalkable(newValue) else { continue }
                
                let newNode = nodes.first(where: {$0.position == newPosition})!
                let cost = directionCosts[direction, default: defaultCost]
                node.edges.insert(AStarEdge(from: node, to: newNode, cost: cost))
            }
        }
        return nodes
    }
}
