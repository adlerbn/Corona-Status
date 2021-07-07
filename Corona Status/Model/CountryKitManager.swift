//
//  CountryKitManager.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import UIKit
import CountryKit

class CountryKitManager {
    static func getFlagImage(name: String) -> UIImage? {
        let countryKit = CountryKit()
        let countries = countryKit.countries
        
        for country in countries {
            if country.name == name {
                return country.flagImage
            }
        }
        return nil
    }
}
