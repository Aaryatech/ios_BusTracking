//
//  clsRoute.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 12/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class clsRoute: NSObject,NSCoding {
    var strBusNumber: String = "";
    var strBusDescription: String="";
    var strBusName: String = "";
    var strRemainingminit: String="";
    var strarrivaltime: String = "";
    var dUser_Stop_lat: Double = 0.0;
    var dUser_Stop_lon: Double = 0.0;
   // var strstop_url: String="";
    
    
    init(strBusNumber: String, strBusDescription: String,strBusName: String,strRemainingminit: String,strarrivaltime: String,dUser_Stop_lat:Double,dUser_Stop_lon:Double)
    {
        self.strBusNumber = strBusNumber
        self.strBusDescription = strBusDescription
        self.strBusName = strBusName
        self.strRemainingminit = strRemainingminit
        self.strarrivaltime = strarrivaltime
        self.dUser_Stop_lat = dUser_Stop_lat
        self.dUser_Stop_lon = dUser_Stop_lon
    }
    
    required init(coder decoder: NSCoder)
    {
        self.strBusDescription = decoder.decodeObject(forKey: "strBusDescription") as? String ?? ""
        self.strBusName = decoder.decodeObject(forKey: "strBusName")as? String ?? ""
        self.strBusNumber = decoder.decodeObject(forKey: "strBusNumber")as? String ?? ""
        self.strRemainingminit = decoder.decodeObject(forKey: "strRemainingminit")as? String ?? ""
        self.strarrivaltime = decoder.decodeObject(forKey: "strarrivaltime")as? String ?? ""
        self.dUser_Stop_lat = decoder.decodeDouble(forKey: "dUser_Stop_lat")
        self.dUser_Stop_lon = decoder.decodeDouble(forKey: "dUser_Stop_lon")
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(strBusDescription, forKey: "strBusDescription")
        coder.encode(strBusName, forKey: "strBusName")
        coder.encode(strBusNumber, forKey: "strBusNumber")
        coder.encode(strRemainingminit, forKey: "strRemainingminit")
        coder.encode(strarrivaltime, forKey: "strarrivaltime")
        coder.encode(dUser_Stop_lat, forKey: "dUser_Stop_lat")
        coder.encode(dUser_Stop_lon, forKey: "dUser_Stop_lon")
      
        
    }
}
