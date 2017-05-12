//
//  BusStopTableViewCell.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 10/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class BusStopTableViewCell: UITableViewCell {
    @IBOutlet weak var lblStopName: UILabel!
    @IBOutlet weak var lblStopDescription: UILabel!
    @IBOutlet weak var lblindex: UILabel!
    @IBOutlet weak var lblTimeRemaing: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
