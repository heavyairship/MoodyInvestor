//
//  AssetTableViewCell.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 10/21/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit

class AssetTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var pricePerShare: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
