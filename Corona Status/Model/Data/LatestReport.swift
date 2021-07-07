//
//  LatestReport.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import Foundation

struct LatestReport: Codable {
    let status: Int
    let type: String
    let data: DataReport
}

struct DataReport: Codable {
    let summary: TotalData
    let change: TotalData
    let generated_on: Int
    let regions: Regions
}

struct TotalData: Codable {
    let total_cases: Int
    let active_cases: Int
    let deaths: Int
    let recovered: Int
    let critical: Int
    let tested: Int
    let death_ratio: Double
    let recovery_ratio: Double
}

struct Regions: Codable {
    let usa: Country
    let iran: Country
    let italy: Country
    let germany: Country
    let uk: Country
}

struct Country: Codable {
    let name: String
    let iso3166a2: String
    let iso3166a3: String
    let iso3166numeric: String
    let total_cases: Int
    let active_cases: Int
    let deaths: Int
    let recovered: Int
    let critical: Int
    let tested: Int
    let death_ratio: Double
    let recovery_ratio: Double
    let change: ChangeStatus
}

struct ChangeStatus: Codable {
    let total_cases: Int
    let active_cases: Int
    let deaths: Int
    let recovered: Int
    let death_ratio: Double
    let recovery_ratio: Double
}
