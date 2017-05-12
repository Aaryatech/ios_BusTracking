//
//  ClsBusData.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 04/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class ClsBusData: NSObject
{
    var strBusNumber: String = "";
    var strBusName: String="";
    var strAvailableSeats: String="";
    var arrRoute = [ClsRouteDetail]()
    var objMaPData:clsMapData!
    
}
