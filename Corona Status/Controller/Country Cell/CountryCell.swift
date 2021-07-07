//
//  CountryCell.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    @IBOutlet weak var deathCountLabel: UILabel!
    @IBOutlet weak var curedCountLabel: UILabel!
    @IBOutlet weak var confirmedCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
