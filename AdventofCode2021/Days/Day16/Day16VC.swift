//
//  Day16VC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 16/12/2021.
//

import Foundation
import UIKit

class Day16VC: AoCVC, AdventDay {
    private static var hexLookup: [Character: String] = [
        "0": "0000",
        "1": "0001",
        "2": "0010",
        "3": "0011",
        "4": "0100",
        "5": "0101",
        "6": "0110",
        "7": "0111",
        "8": "1000",
        "9": "1001",
        "A": "1010",
        "B": "1011",
        "C": "1100",
        "D": "1101",
        "E": "1110",
        "F": "1111"]
    
    private enum OperatorType: Int {
        case sum = 0
        case product = 1
        case minimum = 2
        case maximum = 3
        case literal = 4
        case greaterThan = 5
        case lessThan = 6
        case equal = 7
    }
    
    private class Header {
        let packetVersion: Int
        let typeId: OperatorType
        
        init(bits: String) {
            assert(bits.count == 6)
            let arrayed = bits.convertToStringArray()
            self.packetVersion = Int(arrayed[0...2].joined(), radix: 2)!
            self.typeId = OperatorType(rawValue: Int(arrayed[3...5].joined(), radix: 2)!)!
        }
    }
    
    private class Packet {
        enum ValueType {
            case literal(value: Int)
            case packetOperator(packets: [Packet])
        }
        
        let header: Header
        let valueType: ValueType
        
        var typeId: OperatorType {
            return header.typeId
        }
        
        static func hexParse(_ hexString: String) -> Packet {
            var bits = ""
            for c in hexString {
                bits += Day16VC.hexLookup[c]!
            }
            return bitParse(bits).packet
        }
        
        static func bitParse(_ bitString: String) -> (packet: Packet, numBitsRead: Int) {
            let arrayed = bitString.convertToStringArray()
            let header = Header(bits: arrayed[0...5].joined())
            let subString = String(arrayed[6..<arrayed.count].joined())
            let (valueType, numBitsRead) = parseValue(for: subString, typeId: header.typeId)
            
            let packet = Packet(header: header, valueType: valueType)
            return (packet: packet, numBitsRead: numBitsRead + 6)
        }
        
        init(header: Header, valueType: ValueType) {
            self.header = header
            self.valueType = valueType
        }
        
        static func parseValue(for string: String, typeId: OperatorType) -> (valueType: ValueType, numBitsRead: Int) {
            let arrayed = string.convertToStringArray()
            var numBitsRead = 0
            switch typeId {
            case .literal:
                var literalString = ""
                var isMoreToRead = true
                while isMoreToRead {
                    let isMoreMarker = arrayed[numBitsRead]
                    numBitsRead += 1
                    isMoreToRead = (isMoreMarker == "1")
                    literalString += arrayed[numBitsRead...(numBitsRead + 3)].joined()
                    numBitsRead += 4
                }
                let valueType: ValueType = .literal(value: Int(literalString, radix: 2)!)
                return (valueType: valueType, numBitsRead: numBitsRead)
            default:
                let lengthType = arrayed[numBitsRead]
                numBitsRead += 1
                if lengthType == "0" {
                    let lengthString = arrayed[numBitsRead...(numBitsRead + 14)].joined()
                    numBitsRead += 15
                    let length = Int(lengthString, radix: 2)!
                    let packetEndIndex = numBitsRead + length
                    var packets: [Packet] = []
                    while numBitsRead < packetEndIndex {
                        let remainingString = arrayed[numBitsRead..<arrayed.count].joined()
                        let (packet, packetBitsRead) = Packet.bitParse(remainingString)
                        numBitsRead += packetBitsRead
                        packets.append(packet)
                    }
                    let valueType: ValueType = .packetOperator(packets: packets)
                    return (valueType: valueType, numBitsRead: numBitsRead)
                    
                } else if lengthType == "1" {
                    let numSubPacketsString = arrayed[numBitsRead...(numBitsRead + 10)].joined()
                    numBitsRead += 11
                    let numSubPackets = Int(numSubPacketsString, radix: 2)!
                    var packets: [Packet] = []
                    while packets.count < numSubPackets {
                        let remainingString = arrayed[numBitsRead..<arrayed.count].joined()
                        let (packet, packetBitsRead) = Packet.bitParse(remainingString)
                        numBitsRead += packetBitsRead
                        packets.append(packet)
                    }
                    let valueType: ValueType = .packetOperator(packets: packets)
                    return (valueType: valueType, numBitsRead: numBitsRead)
                } else { fatalError() }
            }
        }
        
        func getVersionNumberSum() -> Int {
            switch valueType {
            case .literal:
                return header.packetVersion
            case .packetOperator(let packets):
                return packets.map({$0.getVersionNumberSum()}).reduce(header.packetVersion, +)
            }
        }
        
        private var packets: [Packet] {
            switch valueType {
            case .literal:
                return []
            case .packetOperator(let packets):
                return packets
            }
        }
        
        private var literalValue: Int? {
            switch valueType {
            case .literal(let value):
                return value
            case .packetOperator:
                return nil
            }
        }
        
        var value: Int {
            switch typeId {
            case .sum:
                return packets.map({$0.value}).reduce(0, +)
            case .product:
                return packets.map({$0.value}).reduce(1, *)
            case .minimum:
                return packets.map({$0.value}).min(by: {$0 < $1})!
            case .maximum:
                return packets.map({$0.value}).max(by: {$0 < $1})!
            case .literal:
                return literalValue!
            case .greaterThan:
                return packets[0].value > packets[1].value ? 1 : 0
            case .lessThan:
                return packets[0].value < packets[1].value ? 1 : 0
            case .equal:
                return packets[0].value == packets[1].value ? 1 : 0
            }
        }
    }
    
    private var input: String = ""
    
    func loadInput() {
        input = defaultInputFileString.loadAsTextString()
    }
    
    func solvePart1() -> String {
        let packet = Packet.hexParse(input)
        let result = packet.getVersionNumberSum()
        return "\(result)"
    }
    
    func solvePart2() -> String {
        let packet = Packet.hexParse(input)
        let result = packet.value
        return "\(result)"
    }
}

extension Day16VC {
    func doTests() {
        let packet1 = Packet.hexParse("D2FE28")
        assert(packet1.header.packetVersion == 6)
        assert(packet1.header.typeId.rawValue == 4)
        switch packet1.valueType {
        case .literal(let value):   assert(value == 2021)
        case .packetOperator:       assert(false)
        }
        
        let packet2 = Packet.hexParse("38006F45291200")
        assert(packet2.header.packetVersion == 1)
        assert(packet2.header.typeId.rawValue == 6)
        switch packet2.valueType {
        case.literal: assert(false)
        case .packetOperator(let packets):
            assert(packets.count == 2)
            switch packets[0].valueType {
            case .packetOperator: assert(false)
            case .literal(let value): assert(value == 10)
            }
            switch packets[1].valueType {
            case .packetOperator: assert(false)
            case .literal(let value): assert(value == 20)
            }
        }
        
        let packet3 = Packet.hexParse("EE00D40C823060")
        assert(packet3.header.packetVersion == 7)
        assert(packet3.header.typeId.rawValue == 3)
        switch packet3.valueType {
        case .literal: assert(false)
        case .packetOperator(let packets):
            assert(packets.count == 3)
            switch packets[0].valueType {
            case .packetOperator: assert(false)
            case .literal(let value): assert(value == 1)
            }
            switch packets[1].valueType {
            case .packetOperator: assert(false)
            case .literal(let value): assert(value == 2)
            }
            switch packets[2].valueType {
            case .packetOperator: assert(false)
            case .literal(let value): assert(value == 3)
            }
        }
        
        let versionTests: [(String, Int)] = [
            ("8A004A801A8002F478", 16),
            ("620080001611562C8802118E34", 12),
            ("C0015000016115A2E0802F182340", 23),
            ("A0016C880162017C3686B18A3D4780", 31),
        ]
        
        for test in versionTests {
            let packet = Packet.hexParse(test.0)
            assert(packet.getVersionNumberSum() == test.1)
        }
        
        let valueTests: [(String, Int)] = [
            ("C200B40A82", 3),
            ("04005AC33890", 54),
            ("880086C3E88112", 7),
            ("CE00C43D881120", 9),
            ("D8005AC2A8F0", 1),
            ("F600BC2D8F", 0),
            ("9C005AC2F8F0", 0),
            ("9C0141080250320F1802104A08", 1)
        ]
        
        for test in valueTests {
            let packet = Packet.hexParse(test.0)
            assert(packet.value == test.1)
        }
    }
}
