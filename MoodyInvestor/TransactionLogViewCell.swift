//
//  TransactionLogViewCell.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/30/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit

class TransactionLogViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var assetName: UILabel!
    @IBOutlet weak var shareChange: UILabel!
    @IBOutlet weak var mood: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
