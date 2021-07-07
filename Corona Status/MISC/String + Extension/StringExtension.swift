//
//  Extension.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
