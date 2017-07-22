//
//  UnderlineTextfield.swift
//  MyThoughtCoach
//
//  Created by Aarya Tech on 23/03/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class UnderlineTextfield: UITextField,UITextFieldDelegate {
    override var tintColor: UIColor! {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        
        tintColor.setStroke()
        
        path.stroke()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        UITextField.appearance().tintColor = .yellow
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UITextField.appearance().tintColor = .black
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
