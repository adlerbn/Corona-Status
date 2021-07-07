//
//  CountryData.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import Foundation

struct CountryData: Codable {
    let status: Int
    let type: String
    let data: DataCountryReport
}

struct DataCountryReport: Codable {
    let summary: TotalData
    let change: TotalData
}
