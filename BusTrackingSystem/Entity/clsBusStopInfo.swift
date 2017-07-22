//
//  clsBusStopInfo.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 11/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class clsBusStopInfo: NSObject,NSCoding {
    
    var strlocation_type: String = "";
    var strparent_station: String="";
    var istop_code: Int ;
    var strstop_desc: String = "";
    var strstop_name: String="";
    var strstop_timezone: String = "";
    var strstop_url: String="";
    var strwheelchair_boarding: String = "";
    var strzone_id: String="";
    var dstop_lat: Double
    var dstop_lon: Double
    var strIndex: String = ""
    var istop_id: Int
    var istop_sequence: Int
    var izone_id: String = ""
    var strarrival_time: String = ""
    
    init(strlocation_type: String, strparent_station: String,istop_code: Int,strstop_desc: String,strstop_name: String,strstop_timezone: String,strstop_url: String,strwheelchair_boarding: String,strzone_id: String,dstop_lat: Double,dstop_lon: Double,strIndex: String,istop_id: Int,istop_sequence: Int,izone_id: String,strarrival_time: String)
    {
        self.strlocation_type = strlocation_type
        self.strparent_station = strparent_station
        self.istop_code = istop_code
        self.strstop_desc = strstop_desc
        self.strstop_name = strstop_name
        self.strstop_timezone = strstop_timezone
        self.strstop_url = strstop_url
        
        self.strwheelchair_boarding = strwheelchair_boarding
        self.strzone_id = strzone_id
        self.dstop_lat = dstop_lat
        self.dstop_lon = dstop_lon
        self.strIndex = strIndex
        self.istop_id = istop_id
        self.istop_sequence = istop_sequence
        
        self.izone_id = izone_id
        self.strarrival_time = strarrival_time
        
        
    }
    required init(coder decoder: NSCoder)
    {
        self.strlocation_type = decoder.decodeObject(forKey: "strlocation_type") as? String ?? ""
        self.strparent_station = decoder.decodeObject(forKey: "strparent_station")as? String ?? ""
        self.istop_code = decoder.decodeInteger(forKey: "istop_code")
        self.strstop_desc = decoder.decodeObject(forKey: "strstop_desc")as? String ?? ""
        self.strstop_name = decoder.decodeObject(forKey: "strstop_name")as? String ?? ""
        self.strstop_timezone = decoder.decodeObject(forKey: "strstop_timezone")as? String ?? ""
        self.strstop_url = decoder.decodeObject(forKey: "strstop_url")as? String ?? ""
        
        
        self.strwheelchair_boarding = decoder.decodeObject(forKey: "strwheelchair_boarding")as? String ?? ""
        self.strzone_id = decoder.decodeObject(forKey: "strzone_id")as? String ?? ""
        self.dstop_lat = decoder.decodeDouble(forKey: "dstop_lat")
        self.dstop_lon = decoder.decodeDouble(forKey: "dstop_lon")
        
        
        self.strIndex = decoder.decodeObject(forKey: "strIndex")as? String ?? ""
      
        self.istop_id = decoder.decodeInteger(forKey: "istop_id")
        self.istop_sequence = decoder.decodeInteger(forKey: "istop_sequence")
        
        self.izone_id = decoder.decodeObject(forKey: "izone_id")as? String ?? ""
        self.strarrival_time = decoder.decodeObject(forKey: "strarrival_time")as? String ?? ""
        
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(strlocation_type, forKey: "strlocation_type")
        coder.encode(strparent_station, forKey: "strparent_station")
        coder.encodeCInt(Int32(istop_code), forKey: "istop_code")
        coder.encode(strstop_desc, forKey: "strstop_desc")
        coder.encode(strstop_name, forKey: "strstop_name")
        coder.encode(strstop_timezone, forKey: "strstop_timezone")
        coder.encode(strstop_url, forKey: "strstop_url")
        
        
        coder.encode(strwheelchair_boarding, forKey: "strwheelchair_boarding")
        coder.encode(strzone_id, forKey: "strzone_id")
        coder.encode(dstop_lat, forKey: "dstop_lat")
        coder.encode(dstop_lon, forKey: "dstop_lon")
        coder.encode(strIndex, forKey: "strIndex")
        
        //coder.encode(istop_id, forKey: "istop_id")
        coder.encodeCInt(Int32(istop_id), forKey: "istop_id")
        coder.encodeCInt(Int32(istop_sequence), forKey: "istop_sequence")
        //coder.encode(istop_sequence, forKey: "istop_sequence")
        coder.encode(izone_id, forKey: "izone_id")
        coder.encode(strarrival_time, forKey: "strarrival_time")
        
    }
    
    
    
    
    
}
