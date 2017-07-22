//
//  clsSPlitTripId.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 14/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class clsSPlitTripId: NSObject,NSCoding
{
    var strType:String = "";
    var strRouteId: String="";
    var strStrSourceAndDestination: String = "";
    var strStrSource: String = "";
    var strStrDestination: String = "";
    var strDirection: String="";
    var strNumber: String = "";
    
    
    init(strType: String, strRouteId: String,strStrSourceAndDestination: String,strStrSource: String,strStrDestination: String,strDirection: String,strNumber: String) {
        self.strRouteId = strRouteId
        self.strType = strType
        self.strStrSourceAndDestination = strRouteId
        self.strDirection = strType
        
        self.strNumber = strRouteId
        
        
        
    }
    
    
    required init(coder decoder: NSCoder) {
        self.strType = decoder.decodeObject(forKey: "strType") as? String ?? ""
        self.strRouteId = decoder.decodeObject(forKey: "strRouteId")as? String ?? ""
        self.strStrSourceAndDestination = decoder.decodeObject(forKey: "strStrSourceAndDestination")as? String ?? ""
        self.strStrSource = decoder.decodeObject(forKey: "strStrSource")as? String ?? ""
        self.strStrDestination = decoder.decodeObject(forKey: "strStrDestination")as? String ?? ""
        self.strDirection = decoder.decodeObject(forKey: "strDirection")as? String ?? ""
        self.strNumber = decoder.decodeObject(forKey: "strNumber")as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(strType, forKey: "strType")
        coder.encode(strRouteId, forKey: "strRouteId")
        coder.encode(strStrSourceAndDestination, forKey: "strStrSourceAndDestination")
        coder.encode(strStrSource, forKey: "strStrSource")
        coder.encode(strStrDestination, forKey: "strStrDestination")
        coder.encode(strDirection, forKey: "strDirection")
        coder.encode(strNumber, forKey: "strNumber")
        
    }
    
}
