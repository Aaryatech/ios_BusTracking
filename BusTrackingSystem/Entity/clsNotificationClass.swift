//
//  clsNotificationClass.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 21/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class clsNotificationClass: NSObject,NSCoding
{
    var objRoute:clsRoute
    var objStopInfo:clsBusStopInfo
    var strComapreString:String
    
    
    init(objRoute: clsRoute, objStopInfo: clsBusStopInfo,strComapreString:String )
    {
        self.objRoute = objRoute
        self.objStopInfo = objStopInfo
       self.strComapreString = strComapreString
    }
    
    required init(coder decoder: NSCoder)
    {
        self.objRoute = (decoder.decodeObject(forKey: "Route") as? clsRoute)!
        self.objStopInfo = (decoder.decodeObject(forKey: "Stop") as? clsBusStopInfo)!
        self.strComapreString = (decoder.decodeObject(forKey: "ComapreString") as? String)!
        
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(objRoute, forKey: "Route")
        coder.encode(objStopInfo, forKey: "Stop")
        coder.encode(strComapreString, forKey: "ComapreString")
    }
    
}
