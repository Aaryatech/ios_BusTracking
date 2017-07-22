//
//  ScheduleRouteTableViewCell.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 10/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class ScheduleRouteTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!

    @IBOutlet weak var lblStationName: UILabel!
    
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var viwline: UIView!
    @IBOutlet weak var viwlineBackground: UIView!
    @IBOutlet weak var btnAlarm: UIButton!
    @IBOutlet weak var btnViewSchedule: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
