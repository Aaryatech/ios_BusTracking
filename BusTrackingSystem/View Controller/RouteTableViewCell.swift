//
//  RouteTableViewCell.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 12/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRouteID: UILabel!
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var lblBusNumber: UILabel!
    @IBOutlet weak var lblBusDescription: UILabel!
    
    @IBOutlet weak var lblArrivalTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
