//
//  RouteDestinationTableViewCell.swift
//  D2D Transit
//
//  Created by Bob K on 10/29/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit
import SVGKit
class RouteDestinationTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleImage: SVGKFastImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var vehicleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeView: UIView!
    @IBOutlet weak var startPointView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
