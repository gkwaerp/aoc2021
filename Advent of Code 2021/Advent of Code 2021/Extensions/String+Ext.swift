//
//  String+Ext.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation
import CryptoKit

extension String {
    func loadAsTextStringArray(fileType: String? = "txt", separator: String = "\n", includeEmptyLines: Bool = false) -> [String] {
        return FileLoader.loadText(fileName: self, fileType: fileType).components(separatedBy: separator).filter({!$0.isEmpty || includeEmptyLines})
    }
    
    func loadAsGrid(fileType: String? = "txt", separator: String = "\n") -> Grid {
        let stringArray = self.loadAsTextStringArray(fileType: fileType, separator: separator)
        return Grid(stringArray: stringArray)
    }
    
    func loadAsTextString(fileType: String? = "txt") -> String {
        return FileLoader.loadText(fileName: self, fileType: fileType)
    }
    
    func loadJSON<T: Codable>(fileType: String? = "txt", parseType: T.Type) -> T {
        return FileLoader.loadJSON(fileName: self, fileType: fileType, parseType: parseType)
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var asStringArray: [String] {
        return self.map({"\($0)"})
    }
    
    var boolValue: Bool? {
        if self.lowercased() == "true" {
            return true
        } else if self.lowercased() == "false" {
            return false
        }
        if let intValue = self.intValue {
            return intValue != 0
        }
        return nil
    }
    
    func ranges(of searchString: String) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex != self.endIndex {
            let range = startIndex..<self.endIndex
            if let foundRange = self.range(of: searchString, range: range) {
                ranges.append(foundRange)
            } else {
                break
            }
            startIndex = self.index(after: startIndex)
        }
        
        return ranges
    }
}

extension String {
    var md5AsHex: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
