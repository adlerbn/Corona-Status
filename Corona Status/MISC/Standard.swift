//
//  Standard.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import Foundation

class Standard {
    static func fixedIntegerStandard(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let number = NSNumber(value: number)
        let str = formatter.string(from: number)
        return str!
    }
}
