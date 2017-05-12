//
//  BusViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 10/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class BusViewController: UIViewController {
var objBusStop:clsBusStopInfo!
    var databsePathStr:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
       
        openDB()
        
        
        // Do any additional setup after loading the view.
    }
    func openDB()
    {
        
        let fileManager = FileManager()
        let filepath=fileManager.urls(for:.documentDirectory,in:.userDomainMask)
        databsePathStr=filepath[0].appendingPathComponent("gtfs.db").path as String;
        if fileManager.fileExists(atPath: databsePathStr as String)
        {
            let mydatabase = FMDatabase(path:databsePathStr as String)
            if mydatabase == nil
            {
                print("Database:\(mydatabase?.lastErrorMessage())")
            }
            if (mydatabase?.open())!
            {
                
                var CurrentDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH.mm.ss"
                let CurrentTime:String = formatter.string(from: CurrentDate)
                print(CurrentTime);
                CurrentDate = Date()+7200
                let toTime:String = formatter.string(from: CurrentDate)
                print(toTime);
                
                //and arrival_time between
                let getBusStop = "select  distinct arrival_time, routes.route_id, trips.trip_id from stop_times INNER JOIN trips ON stop_times.trip_id = trips.trip_id INNER JOIN routes ON routes.route_id = trips.route_id where stop_id =\(objBusStop.istop_id) and arrival_time between '\(CurrentTime)' and  '\(toTime)' order by arrival_time, routes.route_id"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                
                while (resultSet.next()==true)
                {
                    let objRouteInfo = clsRoute();
                    var dict:Dictionary = resultSet.resultDictionary()
                    objRouteInfo.strBusNumber = dict["location_type"] as! String
                    /*objBusStopInfo.strparent_station = dict["parent_station"] as! String
                    objBusStopInfo.strstop_desc = dict["stop_desc"] as! String
                    objBusStopInfo.strstop_name = dict["stop_name"] as! String
                    objBusStopInfo.dstop_lat = dict["stop_lat"] as! Double
                    objBusStopInfo.dstop_lon = dict["stop_lon"] as! Double
                    objBusStopInfo.strstop_timezone = dict["stop_timezone"] as! String
                    objBusStopInfo.strstop_url = dict["stop_url"] as! String
                    objBusStopInfo.istop_code=dict["stop_code"] as! Int
                    objBusStopInfo.istop_id=dict["stop_id"] as! Int
                    objBusStopInfo.izone_id=dict["zone_id"] as! String
                    objBusStopInfo.strIndex = String(UnicodeScalar(index)!)
 
                    arrBusStopInfo.add(objBusStopInfo)
                    index=index+1*/
                }
                
               // print(arrBusStopInfo);
                mydatabase?.close();
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
