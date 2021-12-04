//
//  Image.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation

enum Color {
    case black
    case white
    case transparent
    
    static var printClosure: ColorGrid.PrintBlock = { (value) in
        switch value {
        case .black:
            return " "
        case .white:
            return "X"
        case .transparent:
            return nil
        }
    }
}

class Image {
    var size: IntPoint
    var layers: [ColorGrid]
    
    var width: Int {
        return self.size.x
    }
    
    var height: Int {
        self.size.y
    }

    init(size: IntPoint, values: [Color]) {
        let valuesPerLayer = size.x * size.y
        let numLayers = values.count / valuesPerLayer
        var valuesToUse = values
        var layers = [ColorGrid]()
        for _ in 0..<numLayers {
            let layerData = Array(valuesToUse.prefix(valuesPerLayer))
            valuesToUse = Array(valuesToUse.dropFirst(valuesPerLayer))
            let grid = ColorGrid(size: size, values: layerData)
            layers.append(grid)
        }

        self.size = size
        self.layers = layers
    }

//    func getLayerIndexWithFewestMatching(color: Color) -> Int {
//        var fewestSoFar = self.width * self.height
//        var bestIndex = -1
//        for (index, layer) in self.layers.enumerated() {
//            let matchingInLayer = layer.getNumPixels(matching: color)
//            if matchingInLayer < fewestSoFar {
//                fewestSoFar = matchingInLayer
//                bestIndex = index
//            }
//        }
//        return bestIndex
//    }
//    func getNumMatchingPixelsInLayer(layerIndex: Int, color: Color) -> Int {
//        return self.layers[layerIndex].getNumPixels(matching: color)
//    }
//    lazy var rasterized: Layer = {
//        var rasterizedData = [Color]()
//        for y in 0..<self.height {
//            for x in 0..<self.width {
//                rasterizedData.append(self.findPixel(x: x, y: y)!)
//            }
//        }
//        return Layer(width: self.width, height: self.height, pixels: rasterizedData)
//    }()
//    private func findPixel(x: Int, y: Int) -> Color? {
//        for layer in self.layers {
//            let color = layer.getPixel(x: x, y: y)
//            switch color {
//            case .transparent:
//                break
//            default:
//                return color
//            }
//        }
//
//        return nil
//    }
}
