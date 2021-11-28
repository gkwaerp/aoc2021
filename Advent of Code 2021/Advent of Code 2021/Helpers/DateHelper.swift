//
//  DateHelper.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation
import UIKit

class DateHelper {
    static func getElapsedTimeString(from date: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(date)
        return String(format: "Time = %.4f", elapsedTime)
    }
}
