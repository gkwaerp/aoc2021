//
//  Grid.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation

class Grid<GridValue> {
    typealias PrintBlock = (GridValue) -> (String?)
    typealias GridStorage = [IntPoint: GridValue]
    private var storage: GridStorage
    
    var size: IntPoint
    
    var values: GridStorage.Values {
        return storage.values
    }
    
    var width: Int {
        return self.size.x
    }
    var height: Int {
        return self.size.y
    }
    
    lazy var gridPoints: [IntPoint] = {
        self.size.gridPoints
    }()
    
    init(size: IntPoint, storage: GridStorage) {
        guard size.x > 0, size.y > 0 else { fatalError("Invalid grid, size must be non-negative in both axes.") }
        guard size.x * size.y == storage.count else { fatalError("Invalid grid, size must match element count.") }
        self.size = size
        self.storage = storage
    }
    
    convenience init(size: IntPoint, fillWith value: GridValue) {
        guard size.x > 0, size.y > 0 else { fatalError("Invalid grid, size must be non-negative in both axes.") }
        let values: [GridValue] = (0..<size.magnitude()).map({ _ in return value })
        self.init(size: size, values: values)
    }
    
    /// Square grid
    convenience init(values: [[GridValue]]) {
        let numRows = values.count
        guard let firstRow = values.first else { fatalError("Invalid grid, must contain at least 1 row.") }
        
        let size = IntPoint(x: firstRow.count, y: numRows)
        let flattened = Array(values.joined())
        guard size.x * size.y == flattened.count else { fatalError("Invalid grid, must be square.") }
        
        var storage: GridStorage = [:]
        for y in 0..<values.count {
            for x in 0..<values[y].count {
                storage[IntPoint(x: x, y: y)] = values[y][x]
            }
        }
        
        self.init(size: size, storage: storage)
    }
    
    convenience init(grid: Grid) {
        self.init(size: grid.size, storage: grid.storage)
    }
    
    convenience init(size: IntPoint, values: [GridValue]) {
        guard size.x > 0, size.y > 0 else { fatalError("Invalid grid, size must be non-negative in both axes.") }
        guard size.x * size.y == values.count else { fatalError("Invalid grid, size must match element count.") }

        var storage: GridStorage = [:]
        for i in 0..<values.count {
            let x = i % size.x
            let y = i / size.x
            storage[IntPoint(x: x, y: y)] = values[i]
        }
        
        self.init(size: size, storage: storage)
    }
    
    func updateStorage(_ newStorage: GridStorage) {
        self.storage = newStorage
    }
    
    func isWithinBounds(_ position: IntPoint) -> Bool {
        guard position.x < self.width, position.x >= 0 else { return false }
        guard position.y < self.height, position.y >= 0 else { return false }
        return true
    }
    
    func getValue(at position: IntPoint) -> GridValue? {
        guard isWithinBounds(position) else { return nil }
        return self.storage[position]
    }
    
    func setValue(at position: IntPoint, to value: GridValue) {
        guard isWithinBounds(position) else { return }
        self.storage[position] = value
    }
    
    func getValues(offset from: IntPoint, offsets: [IntPoint]) -> [GridValue] {
        return offsets.compactMap({return self.getValue(at: from + $0)})
    }
    
    func getValues(matching filter: (GridValue) -> (Bool)) -> [GridValue] {
        return self.values.filter(filter)
    }

    func asText(printClosure: PrintBlock) -> String {
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
}

// A*
extension Grid {
    typealias WalkableBlock = (GridValue) -> (Bool)
    
    ///FromNode
    ///ToNode
    typealias CostBlock = (IntPoint, IntPoint) -> Int
    func createAStarNodes(walkableBlock isWalkable: WalkableBlock,
                          allowedDirections: [Direction] = Direction.allCases,
                          costBlock: CostBlock) -> [IntPoint: AStarNode] where GridValue: Hashable {
        var nodes: [IntPoint: AStarNode] = [:]
        for point in self.gridPoints {
            guard let gridValue = self.getValue(at: point) else { continue }
            if isWalkable(gridValue) {
                nodes[point] = AStarNode(position: point)
            }
        }
        
        for node in nodes.values {
            for direction in allowedDirections {
                let newPosition = node.position + direction.movementVector
                guard let newValue = self.getValue(at: newPosition), isWalkable(newValue) else { continue }
                
                let newNode = nodes[newPosition]!
                let cost = costBlock(node.position, newPosition)
                node.edges.insert(AStarEdge(from: node, to: newNode, cost: cost))
            }
        }
        return nodes
    }
}


extension Grid {
    static func defaultPrintClosure() -> PrintBlock where GridValue == String {
        return { value in
            return value.description
        }
    }
    
    static func defaultPrintClosure() -> PrintBlock where GridValue == Int {
        return { value in
            return "\(value)"
        }
    }
    
    static func defaultWalkableBlock() -> WalkableBlock where GridValue == String {
        return { value in
            switch value {
            case "#":
                return false
            default:
                return true
            }
        }
    }
    
    /// Each element in the array corresponds to 1 row
    convenience init(stringArray: [String]) where GridValue == String {
        var values: [GridValue] = []
        for line in stringArray {
            for char in line {
                values.append(String(char))
            }
        }
        let size = IntPoint(x: stringArray.first!.count, y: stringArray.count)
        self.init(size: size, values: values)
    }
}


typealias ColorGrid = Grid<Color>
typealias IntGrid = Grid<Int>
typealias StringGrid = Grid<String>
