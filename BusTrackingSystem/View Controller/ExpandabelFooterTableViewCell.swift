//
//  ExpandabelFooterTableViewCell.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 16/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class ExpandabelFooterTableViewCell: UITableViewCell {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var htStatusView: NSLayoutConstraint!
    @IBOutlet weak var htViewSpace: NSLayoutConstraint!
    @IBOutlet weak var lblIssueNumber: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viwCorrectLine: UIView!
    @IBOutlet weak var imgCorrect: UIImageView!
    @IBOutlet weak var lblReportedOn: UILabel!
    @IBOutlet weak var btnnStatus: UIButton!
    @IBOutlet weak var ViwHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgarrow: UIImageView!
    
    @IBOutlet weak var leadingLowerview: NSLayoutConstraint!
    @IBOutlet weak var leadingupperview: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
                self.htStatusView.constant=54
                upperView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
                imgarrow.image=UIImage(named: "nextarrowico.png")
                
            } else {
                self.ViwHightConstraint.constant = 69.0
                self.htViewSpace.constant=0
                self.htStatusView.constant=35
                upperView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
                imgarrow.image=UIImage(named: "nextarrowico_down.png")
            }
        }
    }

}
