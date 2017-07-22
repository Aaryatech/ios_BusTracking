//
//  clsSetting.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 16/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import GoogleMaps
import SystemConfiguration
class clsSetting: NSObject
{
    func likedlikeBusStop(obj:AnyObject)
    {
        
        let data = UserDefaults.standard.data(forKey: "likeBusStop");
        var arrLikedBusstop = NSMutableArray();
        if (data != nil)
        {
        arrLikedBusstop = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
        ifKeyPresentBusStop(arrLikedBusstop: arrLikedBusstop, obj: obj)
            
        
        }
        else
        {
           ifKeyPresentBusStop(arrLikedBusstop: arrLikedBusstop, obj: obj)
        }
        
        
       
    }
    
    
    
    
    
    func ifKeyPresentBusStop (arrLikedBusstop:NSMutableArray,obj:AnyObject)
    {
        
        var isfound:Bool = false
        for objlikeBusstop in arrLikedBusstop
        {
            if (objlikeBusstop as! clsBusStopInfo).istop_id == (obj as! clsBusStopInfo).istop_id
            {
                isfound = true
                arrLikedBusstop.remove(objlikeBusstop)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrLikedBusstop)
                UserDefaults.standard.set(encodedData, forKey: "likeBusStop")
                break;
            }
        }
        if isfound==false
        {
            arrLikedBusstop.add(obj)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrLikedBusstop)
            UserDefaults.standard.set(encodedData, forKey: "likeBusStop")
           
        }
        
       
    }
    
    
    
    func NotificationObject(obj:AnyObject)
    {
        
        let data = UserDefaults.standard.data(forKey: "Notification");
        var arrNotification = NSMutableArray();
        if (data != nil)
        {
            arrNotification = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
        }
       
        
        arrNotification.add(obj)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrNotification)
        UserDefaults.standard.set(encodedData, forKey: "Notification")
        
    }
    
    func RemoveNotification (strMatchString:String) -> clsNotificationClass
    {
        let data = UserDefaults.standard.data(forKey: "Notification");
        let datatemp = UserDefaults.standard.data(forKey: "NotificationTemp");
        var arrNotication = NSMutableArray();
        var arrNoticationTemp = NSMutableArray();
       
        if (data != nil)
        {
            arrNotication = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
            
        }
        if (datatemp != nil)
        {
            arrNoticationTemp = (NSKeyedUnarchiver.unarchiveObject(with: datatemp!) as? NSMutableArray)!
            
        }
        var passNotoficationObject:clsNotificationClass!
        var isfound:Bool = false
        for objnotification in arrNotication
        {
            if ((objnotification as! clsNotificationClass).strComapreString == strMatchString)
            {
               
                isfound=true
                passNotoficationObject = clsNotificationClass(objRoute: (objnotification as! clsNotificationClass).objRoute, objStopInfo: (objnotification as! clsNotificationClass).objStopInfo,strComapreString:(objnotification as! clsNotificationClass).strComapreString )  ;
                arrNoticationTemp.add(objnotification)
                arrNotication.remove(objnotification)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrNotication)
                let encodedDatatemp = NSKeyedArchiver.archivedData(withRootObject: arrNoticationTemp)
                UserDefaults.standard.set(encodedData, forKey: "Notification")
                UserDefaults.standard.set(encodedDatatemp, forKey: "NotificationTemp")
                break;
            }
        }
        
        if isfound == false
        {
            for objnotification in arrNoticationTemp
            {
                if ((objnotification as! clsNotificationClass).strComapreString == strMatchString)
                {
                     passNotoficationObject = clsNotificationClass(objRoute: (objnotification as! clsNotificationClass).objRoute, objStopInfo: (objnotification as! clsNotificationClass).objStopInfo,strComapreString:(objnotification as! clsNotificationClass).strComapreString )  ;
                }
            }
        }
        return passNotoficationObject!;
    }
    
    func likedRoute(obj:AnyObject)
    {
        
        let data = UserDefaults.standard.data(forKey: "likedRoute");
        var arrLikedRoute = NSMutableArray();
        if (data != nil)
        {
            arrLikedRoute = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
            ifKeyPresentlikedRoute(arrLikedRoute: arrLikedRoute, obj: obj)
            
            
        }
        else
        {
            ifKeyPresentlikedRoute(arrLikedRoute: arrLikedRoute, obj: obj)
        }
        /*NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
         NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"savedArray"];
         if (dataRepresentingSavedArray != nil)
         {
         NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
         if (oldSavedArray != nil)
         objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
         else
         objectArray = [[NSMutableArray alloc] init];
         }*/
    }
    
    
    func ifKeyPresentlikedRoute (arrLikedRoute:NSMutableArray,obj:AnyObject)
    {
        
        var isfound:Bool = false
        for objlikeBusstop in arrLikedRoute
        {
            if (objlikeBusstop as! clsRoute).strBusName == (obj as! clsRoute).strBusName
            {
                isfound = true
                arrLikedRoute.remove(objlikeBusstop)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrLikedRoute)
                UserDefaults.standard.set(encodedData, forKey: "likedRoute")
                break;
            }
        }
        if isfound==false
        {
            arrLikedRoute.add(obj)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrLikedRoute)
            UserDefaults.standard.set(encodedData, forKey: "likedRoute")
            
        }
        
        
        
    }
    
    
    func checkBusstopIsLikeOrNot(obj:AnyObject) -> Bool
    {
        let data = UserDefaults.standard.data(forKey: "likeBusStop");
        var arrLikedBusstop = NSMutableArray();
        if (data != nil)
        {
            arrLikedBusstop = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
            var isfound:Bool = false
            for objlikeBusstop in arrLikedBusstop
            {
                if (objlikeBusstop as! clsBusStopInfo).istop_id == (obj as! clsBusStopInfo).istop_id
                {
                    isfound = true
                    break;
                }
            }
            
            return isfound;
        }
        else
        {
            return false;
        }
        
    }
    
    
    
    
    func checkRouteIsLikeOrNot(obj:AnyObject) -> Bool
    {
        let data = UserDefaults.standard.data(forKey: "likedRoute");
        var arrLikedRoute = NSMutableArray();
        if (data != nil)
        {
            arrLikedRoute = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
            var isfound:Bool = false
            for objlikeRoute in arrLikedRoute
            {
                if (objlikeRoute as! clsRoute).strBusName == (obj as! clsRoute).strBusName
                {
                    isfound = true
                    break;
                }
            }
            
            return isfound;
        }
        else
        {
            return false;
        }
        
    }
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        let trueCourse = bearing * M_PI / 180;
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(trueCourse))
        let lon2 = lon1 + atan2(sin(trueCourse) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}
