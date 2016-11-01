//
//  RouteTableViewCell.swift
//  D2D Transit
//
//  Created by Bob K on 10/29/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit
import SVGKit
class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var providerTitleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var getGoingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerImageView: SVGKFastImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
