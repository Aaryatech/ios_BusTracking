//
//  ExpandableTableViewCell.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 14/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var htStatusView: NSLayoutConstraint!
    @IBOutlet weak var htViewSpace: NSLayoutConstraint!
    @IBOutlet weak var lblIssueNumber: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblReportedOn: UILabel!
    @IBOutlet weak var lblGrivamceType: UILabel!
     @IBOutlet weak var btnViewDetail: UIButton!
    @IBOutlet weak var btnnStatus: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var ViwHightConstraint: NSLayoutConstraint!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
                // Configure the view for the selected state
    }
    
    
    var isExpanded:Bool = false
        {
        didSet
        {
            if !isExpanded {
                self.ViwHightConstraint.constant = 0.0
                self.htViewSpace.constant=25
                 self.htStatusView.constant=50
                upperView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                imgArrow.image=UIImage(named: "nextarrowico.png")
                
            } else {
                self.ViwHightConstraint.constant = 160.0
                self.htViewSpace.constant=0
                self.htStatusView.constant=35
                upperView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
                imgArrow.image=UIImage(named: "nextarrowico_down.png")
            }
        }
    }


}
