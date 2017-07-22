//
//  clsContactNumber.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 03/07/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class clsContactNumber: NSObject,NSCoding
{
    var strName: String="";
    var strContactNumber: String = "";
    init(strName: String, strContactNumber: String)
    {
        self.strContactNumber = strContactNumber
        self.strName = strName
    }
    required init(coder decoder: NSCoder)
    {
        self.strContactNumber = decoder.decodeObject(forKey: "strContactNumber") as? String ?? ""
        self.strName = decoder.decodeObject(forKey: "strName")as? String ?? ""
    }
    func encode(with coder: NSCoder)
    {
        coder.encode(strContactNumber, forKey: "strContactNumber")
        coder.encode(strName, forKey: "strName")
    }
}
