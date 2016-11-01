//
//  BigRouteOriginTableViewCell.swift
//  D2D Transit
//
//  Created by Bob K on 10/29/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit
import SVGKit

class BigRouteOriginTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var vehicleImage: SVGKFastImageView!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var stopsLabel: UILabel!
    @IBOutlet weak var downArrowLabel: UILabel!
    @IBOutlet weak var startPointView: UIView!
    @IBOutlet weak var routeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
