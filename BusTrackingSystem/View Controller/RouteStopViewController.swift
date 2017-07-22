//
//  RouteStopViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 14/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import UserNotifications
class RouteStopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,kDropDownListViewDelegate,passtodetail,passDate {
    var arrStops=NSMutableArray();
    @IBOutlet weak var btnSelectedStop: UIButton!
    @IBOutlet weak var btnSelectedDate: UIButton!
    var   Dropobj=DropDownListView()
    let arrRouteStops=NSMutableArray();
    var databsePathStr:String = "";
    @IBOutlet weak var lblDestination: UILabel!
    var  objbusStop:clsBusStopInfo!
    @IBOutlet weak var lblSource: UILabel!
    var objroute:clsRoute!
    var arrfilter = NSMutableArray();
    @IBOutlet var tblBusStopRoutlist: UITableView!
    var curDate:NSDate!
    var formatter:DateFormatter!
    var changeDate:String!
    
    
    @IBAction func btnDatePressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DatepickerViewController") as! DatepickerViewController
        viewController.delegate=self;
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        viewController.view.frame = view.bounds
        self.view!.addSubview(viewController.view!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openDB1();
        checkReminder();
        navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = String(objroute.strBusNumber);
        
        btnSelectedStop.setTitle("\(objbusStop.strstop_name)",for: .normal)
        
        let data = UserDefaults.standard.data(forKey: "routeString");
        
           // let splistString = NSKeyedUnarchiver.unarchiveObject(with: data!) as? clsSPlitTripId
        let data1 = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        self.btnSelectedDate.setTitle(formatter.string(from: data1),for: .normal)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/YYYY"
        //self.btnSelectedDate.setTitle(formatter.string(from: date),for: .normal)
        
        let CurrentDate:Date = Date()
        changeDate = formatter1.string(from: CurrentDate);
        
        LISTOFBUSSTOP()
        // Do any additional setup after loading the view.
    }

    
    
    func checkReminder()
    {
        let data = UserDefaults.standard.data(forKey: "Notification");
        var arrNotification = NSMutableArray();
        if (data != nil)
        {
            arrNotification = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
        }
        arrfilter.removeAllObjects();
        for objnotification in arrNotification
        {
            let objnotification1:clsNotificationClass = objnotification as! clsNotificationClass
            if objnotification1.objRoute.strBusNumber == objroute.strBusNumber
            {
                arrfilter.add(objnotification1)
            }
            
        }
        
        
    }
    func alarmMarkAsRed(objStop:clsBusStopInfo) -> Bool
    {
        var isfound:Bool = false
        for objfilter in arrfilter
        {
            let objnotification1:clsNotificationClass = objfilter as! clsNotificationClass
            if objnotification1.objStopInfo.istop_id == objStop.istop_id && objnotification1.objStopInfo.strarrival_time == objStop.strarrival_time
            {
                isfound = true
                break;
            }
            
        }
        if isfound == false
        {
            return false
        }
        else
        {
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openDB1()
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
                
                /* var CurrentDate = Date()
                 let formatter = DateFormatter()
                 formatter.dateFormat = "HH.mm.ss"
                 let CurrentTime:String = formatter.string(from: CurrentDate)
                 print(CurrentTime);
                 CurrentDate = Date()+7200
                 let toTime:String = formatter.string(from: CurrentDate)
                 print(toTime);*/
                
                //and arrival_time between
                
                
                let getBusStop = "select arrival_time,stop_name,stop_times.trip_id from stop_times INNER JOIN trips  on stop_times.trip_id = trips.trip_id JOIN stops  on stop_times.stop_id  = stops.stop_id  where stop_times.stop_id = '\(objbusStop.istop_id)'and  trips.route_id ='\(objroute.strBusNumber)'order by arrival_time"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                arrRouteStops.removeAllObjects();
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    let objBusStopInfo = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code:0,strstop_desc: "",strstop_name: dict["stop_name"] as! String,strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: 0.0,dstop_lon: 0.0,strIndex: "",istop_id: 0,istop_sequence:0,izone_id:"",strarrival_time: dict["arrival_time"] as! String);
                    
                    let strtime    = dict["arrival_time"] as! String
                    let arrtime = strtime.components(separatedBy: ":")
                    
                    if arrtime.count>0
                    {
                        let strTime:Int = Int(arrtime[0])!
                        if strTime < 24
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss" //Your date format
                            let date = dateFormatter.date(from: objBusStopInfo.strarrival_time as! String)! //according to date format your date string
                            print(date)
                            
                            let now = Date()
                            
                            let elapsed = Date().timeIntervalSince(date)
                            let min = elapsed/3600
                            let dateFormatter11 = DateFormatter()
                            dateFormatter11.dateFormat = "HH:mm";
                            print(dateFormatter11.string(from: date));
                            let Remaingtime:String = dateFormatter11.string(from: date)
                            
                            
                            let currentTime:String = dateFormatter11.string(from: now)
                            
                            print(currentTime)
                            
                            let TimeDifference:Int = self.TimeDifference(CurrentTime: currentTime, GetTime: Remaingtime)
                            objBusStopInfo.istop_code = TimeDifference;
                            
                            //objBusStopInfo.strstop_name = dict["stop_name"] as! String
                            //objBusStopInfo.istop_sequence = dict["stop_sequence"] as! Int
                            //objBusStopInfo.strarrival_time = dict["arrival_time"] as! String
                            
                            arrRouteStops.add(objBusStopInfo)
                        }
                    }
                    
                    
                    
                }
                
                print(arrRouteStops);
                mydatabase?.close();
            }
        }
        
        GetSourceDestination()
        tblBusStopRoutlist.reloadData();
        
        
    }
    
    
    @IBAction func btnselectedstoppressed(_ sender: Any)
    {
        
        //showPopUpWithTitle(popupTitle:"select BusStop",withOption:arrStops,xy:(((SCREEN_WIDTH/2) - (287/2)), 130), GSizeMake(287, SCREEN_HEIGHT/1.8) ,isMultiple:NO  )
        Dropobj = DropDownListView(title: "Select Bus Stop", options: arrStops as [AnyObject], xy: CGPoint(x:(self.view.frame.size.width-280)/2, y:150), size: CGSize(width: 280, height: (self.view.frame.size.height-200)), isMultiple: false, parseKey: "stop_name")
        Dropobj.show(in: self.view, animated: true)
       // 0.0 G:108.0 B:194.0 alpha:0.70
        Dropobj.delegate=self;
        Dropobj.setBackGroundDropDown1_R(39, g: 57.0, b: 128.0, alpha: 0.70)
    }
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int)
    {
        let dict:Dictionary = arrStops[anIndex] as! [String : Any];
        
        let objBusStopInfo = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code:0,strstop_desc: "",strstop_name: dict["stop_name"]! as! String ,strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: 0.0,dstop_lon: 0.0,strIndex: "",istop_id: dict["stop_id"]! as! Int ,istop_sequence:dict["stop_sequence"]! as! Int ,izone_id:"",strarrival_time: dict["arrival_time"]! as! String );
        objbusStop=objBusStopInfo;
        btnSelectedStop.setTitle("\(objbusStop.strstop_name)",for: .normal)
        openDB1();
    }
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        
    }
    func dropDownListViewDidCancel() {
        
        
    }
    
    func GetSourceDestination()
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
                
                /* var CurrentDate = Date()
                 let formatter = DateFormatter()
                 formatter.dateFormat = "HH.mm.ss"
                 let CurrentTime:String = formatter.string(from: CurrentDate)
                 print(CurrentTime);
                 CurrentDate = Date()+7200
                 let toTime:String = formatter.string(from: CurrentDate)
                 print(toTime);*/
                
                //and arrival_time between
                
                var diectrion:String = ""
                if objroute.strBusName.uppercased().range(of:"DOWN") != nil
                {
                    diectrion = "DOWN";
                }
                else if objroute.strBusName.uppercased().range(of:"UP") != nil
                {
                    diectrion = "UP";
                }
                else if objroute.strBusName.uppercased().range(of:"ROUND") != nil
                {
                 diectrion = "ROUND";
                }
                
                
                let getBusStop = "select distinct source,destination from stop_routes  where route_id = '\(objroute.strBusNumber)' and UPPER(direction) = '\(diectrion)'"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                
                while (resultSet.next()==true)
                {
                   
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    lblSource.text = dict["source"] as? String
                    //objBusStopInfo.istop_sequence = dict["stop_sequence"] as! Int
                    lblDestination.text = dict["destination"] as? String
                    
                    
                }
                
                //print(arrRouteInfo);
                mydatabase?.close();
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return arrRouteStops.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleRoute1")as! ScheduleRouteTableViewCell;
        let objbusStop:clsBusStopInfo = arrRouteStops[indexPath.row] as! clsBusStopInfo ;
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let CurrentTime:Date = formatter.date(from:objbusStop.strarrival_time )!
        print(CurrentTime);
        
        
        formatter.dateFormat = "hh:mm aa"
        let strformatedTime:String = formatter.string(from: CurrentTime)
        
        if(alarmMarkAsRed(objStop: objbusStop))
        {
            let like = (UIImage(named: "alarm-clock.png")?.withRenderingMode(.alwaysOriginal))!
            cell.btnAlarm.setImage(like, for: UIControlState.normal)
            
        }
        else
        {
            let like = (UIImage(named: "alram_ico.png")?.withRenderingMode(.alwaysOriginal))!
            cell.btnAlarm.setImage(like, for: UIControlState.normal)
        }
        
        
        cell.lblTime?.text=strformatedTime;
        cell.lblStationName?.text=objbusStop.strstop_name;
        cell.btnAlarm.tag=indexPath.row
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/YYYY"
         //self.btnSelectedDate.setTitle(formatter.string(from: date),for: .normal)
       // let Date1:Date = formatter1.date(from: (btnSelectedDate.titleLabel?.text)!)!
        let CurrentDate:Date = Date()
        let strDate:String = formatter1.string(from: CurrentDate);
      //  let formatedDate:Date = formatter1.date(from:strDate )!
        
        if changeDate == strDate
        {
           
        
        
        if objbusStop.istop_code==2
        {
            cell.lblTime.textColor = UIColor(red: 57/255, green: 186/255, blue: 236/255, alpha: 1)
            cell.lblStationName.textColor = UIColor(red: 57/255, green: 186/255, blue: 236/255, alpha: 1)
            cell.btnAlarm.isHidden = true;
        }
        else
        {
            cell.lblTime.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.lblStationName.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.btnAlarm.isHidden = false;
        }
        }
        else
        {
            cell.lblTime.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.lblStationName.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.btnAlarm.isHidden = false;
        }
       // cell.btnViewSchedule.layer.cornerRadius = 10
        //cell.btnViewSchedule.layer.borderWidth = 1
       // cell.btnViewSchedule.layer.borderColor = UIColor.clear.cgColor
        
        
        
        
        
        return cell;
        
    }
    
    @IBAction func btynAlarm(_ sender: UIButton)
    {
        let objbusStop:clsBusStopInfo=arrRouteStops.object(at: sender.tag) as! clsBusStopInfo;
        
        var isfound:Bool = false
        
        let str:String = "\(self.objroute.strBusNumber)~\(objbusStop.strstop_name)~\(objbusStop.strarrival_time)"
        let data = UserDefaults.standard.data(forKey: "Notification");
        var arrNotication = NSMutableArray();
        if (data != nil)
        {
            arrNotication = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
            
        }
        for objnotification in arrNotication
        {
            if ((objnotification as! clsNotificationClass).strComapreString == str)
            {
                isfound=true;
                let objSetting = clsSetting()
                
                objSetting.RemoveNotification(strMatchString: str);
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [str])
                RemoveSubview()
            }
        }
        /*
         let app:UIApplication = UIApplication.shared
         for oneEvent in app.scheduledLocalNotifications! {
         let notification = oneEvent as UILocalNotification
         let info = notification.userInfo as? Dictionary<String,Any>
         let strMatchString:String = (info!["route"] as! String?)!
         
         
         if strMatchString == str
         {
         //Cancelling local notification
         isfound=true;
         let objSetting = clsSetting()
         objSetting.RemoveNotification(strMatchString: str);
         app.cancelLocalNotification(notification)
         break;
         }
         }*/
        
        
        
        
        if(isfound==false)
        {

        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ReminderViewController") as! ReminderViewController
        viewController.objroute=self.objroute
        viewController.delegate=self
        viewController.objBusStopInfo = objbusStop
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        viewController.view.frame = view.bounds
       self.view!.addSubview(viewController.view!)
        
        }
        
    }
    
    
    func LISTOFBUSSTOP()
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
                
                /* var CurrentDate = Date()
                 let formatter = DateFormatter()
                 formatter.dateFormat = "HH.mm.ss"
                 let CurrentTime:String = formatter.string(from: CurrentDate)
                 print(CurrentTime);
                 CurrentDate = Date()+7200
                 let toTime:String = formatter.string(from: CurrentDate)
                 print(toTime);*/
                
                //and arrival_time between
                
                
                let getBusStop = "select stops.stop_id, stop_name, stop_sequence,stop_times.arrival_time,stops.stop_lat, stops.stop_lon from stop_times INNER JOIN stops  on stop_times.stop_id = stops.stop_id  where trip_id = '\(objroute.strBusName)' order by stop_sequence"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                arrStops.removeAllObjects();
                
                while (resultSet.next()==true)
                {
                    let dict:Dictionary = resultSet.resultDictionary()
                    
                    // let objBusStopInfo = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code:0,strstop_desc: "",strstop_name: dict["stop_name"] as! String,strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: 0.0,dstop_lon: 0.0,strIndex: "",istop_id: dict["stop_id"] as! Int,istop_sequence:dict["stop_sequence"] as! Int,izone_id:"",strarrival_time: dict["arrival_time"] as! String);
                    
                    //objBusStopInfo.istop_id = dict["stop_id"] as! Int
                    //objBusStopInfo.strstop_name = dict["stop_name"] as! String
                    //objBusStopInfo.istop_sequence = dict["stop_sequence"] as! Int
                    //objBusStopInfo.strarrival_time = dict["arrival_time"] as! String
                    
                    arrStops.add(dict)
                    
                }
                
                //print(arrRouteInfo);
                mydatabase?.close();
            }
        }
        
    }
 
    func TimeDifference(CurrentTime:String, GetTime:String) -> Int
    {
        var CH = String();
        var GH = String();
        var CM = String();
        var GM = String();
        let TM:Int
        let arrCurrentTime = CurrentTime.components(separatedBy: ":")
        if arrCurrentTime.count>0
        {
            CH=arrCurrentTime[0]
            CM=arrCurrentTime[1]
        }
        
        let arrGetTime = GetTime.components(separatedBy: ":")
        if arrGetTime.count>0
        {
            GH=arrGetTime[0]
            GM=arrGetTime[1]
        }
        if Int(GH)! >= Int(CH)!
        {
            let TH:Int  = Int(GH)! - Int(CH)!;
            if TH > 0
            {
                TM = (60 - Int(CM)!) + Int(GM)!//RED
                return 1
            }
            else
            {
                TM = Int(GM)! - Int(CM)!
                if TM>0
                {
                    //red
                    return 1
                }
                else
                {
                    //blue
                    return 2
                }
            }
        }
        else
        {
            TM = 0;//BLUE
            return 2
        }
        
        
    }
    
    func RemoveSubview()
    {
        checkReminder();
        tblBusStopRoutlist.reloadData();
    }
   func RemoveSubview(date:Date)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        self.btnSelectedDate.setTitle(formatter.string(from: date),for: .normal)
        changeDate = formatter.string(from: date)
        tblBusStopRoutlist.reloadData();
    }
    
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

