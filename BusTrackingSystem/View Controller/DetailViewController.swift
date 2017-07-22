//
//  DetailViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 04/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import GoogleMaps
import AFNetworking
import NVActivityIndicatorView
import UserNotifications
class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,passtodetail {
    @IBOutlet weak var tblBusList: UITableView!
    var objBus:ClsBusData!
   // var mapView: GMSMapView!
    @IBOutlet weak var mapView: GMSMapView!
  
    var dobFirstLat:Double!
    var dobFirstLong:Double!
    var dobLastLat:Double!
    var dobLastLong:Double!
    var databsePathStr:String = "";
    var title1:String = ""
    var objroute:clsRoute!
    var isCommingFrom:Int = 0
    var objUserSelectedBusStop:clsBusStopInfo!
    let arrStops=NSMutableArray();
    let arrpath=NSMutableArray();
    var iLastSequence=0;
    var IsRefreshON:Bool = false
     var arrfilter = NSMutableArray();
     let BusMarker = GMSMarker()
    var IsofflineGlobal = true
    var strBusNumber = "NA"
      var strTital:String="";
    @IBOutlet weak var htTableView: NSLayoutConstraint!
    
    @IBOutlet weak var btnbus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        

        
       // let editImage   = UIImage(named: "ic_seat")!
        //let like = UIImage(named: "favorite_ico")!
       
       
       
        tblBusList.tableFooterView = UIView(frame: .zero)
        navigationController?.navigationBar.tintColor = .white
        //self.navigationItem.title = title1;
        checkLiked();
        checkReminder();
        openDB1();
        self.title = strTital
        btnbus.layer.borderColor = UIColor.clear.cgColor
        btnbus.layer.cornerRadius = 0.5 * btnbus.bounds.size.width
        btnbus.clipsToBounds = true
        self.view.bringSubview(toFront: btnbus)
        
        
        
        
       // self.htTableView.constant=CGFloat(self.view.frame.size.height-((self.view.frame.size.width*3)/4))
       
        //let frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: (self.view.frame.size.width*3)/4)
        //print("&Userlatitude=\(objBus.objMaPData.DobCurrentUserlatitude)")
        // print("&Userlatitude=\(objBus.objMaPData.DobCurrentUserlongitude)")
        //let camera = GMSCameraPosition.camera(withLatitude:objBus.objMaPData.DobCurrentUserlatitude, longitude:objBus.objMaPData.DobCurrentUserlongitude,zoom: 15)
        //let camera = GMSCameraPosition.camera(withLatitude:20.010270, longitude:73.768433,zoom: 14)
        
       /* mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.map = mapView
        var i:Int = 0;*/
       
        /*for route in (objBus.arrRoute)
        {
            i += 1;
            let camera1 = GMSCameraPosition.camera(withLatitude:route.Doblatitude,
                                                   longitude: route.Doblongitude,
                                                   zoom: 15)
            let markerNextStop = GMSMarker()
            markerNextStop.position = camera1.target
            markerNextStop.snippet = route.strStopName
            markerNextStop.icon = UIImage(named: "placeholder")
            markerNextStop.map = mapView
            if i==1
            {
                dobFirstLat = route.Doblatitude;
                dobFirstLong = route.Doblongitude;
            }
            if i==objBus.arrRoute.count
            {
                dobLastLat = route.Doblatitude;
                dobLastLong = route.Doblongitude;
            }
            
           }
        
        
        let camera2 = GMSCameraPosition.camera(withLatitude:objBus.objMaPData.DobCurrentBuslatitude, longitude: objBus.objMaPData.DobCurrentBuslongitude,zoom: 15)
         //let camera2 = GMSCameraPosition.camera(withLatitude:20.007910, longitude: 73.769917,zoom: 14)
        let markerbus = GMSMarker()
        markerbus.position = camera2.target
        markerbus.icon = UIImage(named: "ic_bus_icon")
        markerbus.map = mapView
        */
        //view = mapView1
        
        //GetStateData(strStartlat: 38.889931, strStartlong: -77.009003, strEndtlat: 40.730610, strEndlong: -73.935242)
        //GetStateData(strStartlat: dobFirstLat, strStartlong: dobFirstLong, strEndtlat: dobLastLat, strEndlong: dobLastLong)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if IsofflineGlobal==false
        {
            mapView.clear();
        }
        //GMSMarker *pin in self.mapView_.markers
        /* for var pin:GMSMarker in self.mapView.markers
         {
         
         }
         */
        IsRefreshON = true;
        openDB1();
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
    
    override func viewWillAppear(_ animated: Bool)
    {
       
    }
    
    @IBAction func btnHomeBuspressed(_ sender: Any)
    {
         let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkLiked()
    {
        let objsetting = clsSetting()
        let isliked:Bool=objsetting.checkRouteIsLikeOrNot(obj: objroute)
        let like:UIImage
        if isliked==true
        {
            like = (UIImage(named: "favorite_yellow_ico")?.withRenderingMode(.alwaysOriginal))!
        }
        else
        {
            like = (UIImage(named: "favorite_ico")?.withRenderingMode(.alwaysOriginal))!
            
        }
        
        let ShareImage = UIImage(named: "ic_share")?.withRenderingMode(.alwaysOriginal)
        let refreshImage = UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal)
        // let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: nil)
       /* let likeButton = UIBarButtonItem(image: like,  style: .plain, target: self, action: #selector(Like))
        let ShareButton = UIBarButtonItem(image: ShareImage,  style: .plain, target: self, action: #selector(Share))
        let RefreshButton = UIBarButtonItem(image: refreshImage,  style: .plain, target: self, action: #selector(refresh))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -30*/
        
        let likeBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        likeBtn.setImage(like, for: UIControlState.normal)
        likeBtn.addTarget(self, action: #selector(Like), for: UIControlEvents.touchUpInside)
        
        let likebarBtn = UIBarButtonItem(customView: likeBtn)
        
        let ShareButton: UIButton = UIButton(frame: CGRect(x: -20, y: 0, width: 25, height: 25))
        ShareButton.setImage(ShareImage, for: UIControlState.normal)
        ShareButton.addTarget(self, action: #selector(Share), for: UIControlEvents.touchUpInside)
        
        let SharebarBtn = UIBarButtonItem(customView: ShareButton)
        
        let RefreshButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        RefreshButton.setImage(refreshImage, for: UIControlState.normal)
        RefreshButton.addTarget(self, action: #selector(refresh), for: UIControlEvents.touchUpInside)
        
        let RefreshbarBtn = UIBarButtonItem(customView: RefreshButton)
        
        
        
        navigationItem.rightBarButtonItems = [SharebarBtn,likebarBtn,RefreshbarBtn]
        
    }
    func Share(_ sender: UIButton)
    {
        /*let firstActivityItem = "Currently i am travalling in bus numer \(objroute.strBusNumber) from \(title1)"
        let secondActivityItem : NSURL = NSURL(string: "http://playstore.com")!
        // If you want to put an image
        let image : UIImage = UIImage(named: "app_icon")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender )
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
 */
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SharedViewController") as! SharedViewController
        viewController.strBusName = " \(title1)"
        viewController.strStatus = "Running"
        viewController.strStation = objUserSelectedBusStop.strstop_name
        viewController.strBusPhysicalNumber = strBusNumber
        let CurrentDate:Date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY hh:mm:ss aa"
        let strformatedTime:String = formatter.string(from: CurrentDate)
        viewController.strSharedOn = strformatedTime
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        viewController.view.frame = view.bounds
        self.view!.addSubview(viewController.view!)
    }
    func refresh(_ sender: UIButton)
    {
        if IsofflineGlobal==false
        {
        mapView.clear();
        }
        //GMSMarker *pin in self.mapView_.markers
       /* for var pin:GMSMarker in self.mapView.markers
        {
            
        }
        */
        IsRefreshON = true;
       openDB1();
    }
    
    func Like(_ sender: UIButton)
    {
        let objsetting = clsSetting()
        
        objsetting.likedRoute(obj: objroute)
        checkLiked();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetStateData(strStartlat: Double,strStartlong:Double,strEndtlat: Double,strEndlong:Double)
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
       // https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626&key=YOUR_API_KEY
        
        let str:String = "units=metric&origins=\(strStartlat),\(strStartlong)&destinations=\(strEndtlat),\(strEndlong)&key=AIzaSyAPTcCu-y7NALEZht39zHbhPRRmzvXBDnE"
      
        let strUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?"+str;
        // var arrResult:Array=[clsCountry]();
        print(strUrl)
        // var response1:NSDictionary?;
        manager.get(strUrl, parameters: nil, progress: nil, success:
            {
                requestOperation, response in
                 print(response)
                var response1 = Dictionary<String, Any>()
                response1 = response as! Dictionary
                print(response1 as Any)
                
                var countryData:Array=[Dictionary<String, Any>()]
                countryData=response1["rows"] as! Array
                
                var distance11 = Dictionary<String,Any>()
                distance11 = countryData[0]
                
                var element:Array = [Dictionary<String, Any>()]
                element=distance11["elements"] as! Array
                var duration = Dictionary<String,Any>()
                duration = element[0]
                var duration23=Dictionary<String, Any>()
                duration23 = duration["duration"] as! Dictionary
                let str:String = duration23["text"] as! String
                print(str);
                                // self.arrCountry = response1["Data"] as! [clsCountry]
                
                
                
                if (countryData.count > 0)
                {
                    var routeDict = countryData[0];
                    //var routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                     var routeOverviewPolyline = Dictionary<String, Any>()
                    routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary
                    
                   let points:String = routeOverviewPolyline["points"] as! String;
                   let path = GMSMutablePath(fromEncodedPath: points)
                   
                    let polygon = GMSPolygon(path: path)
                    polygon.strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1);
                    polygon.strokeWidth = 1;
                    polygon.map = self.mapView;
                }
                
                
                
                
                //self.clvCountry.reloadData()
                
                
            },
                    failure:
            {
                requestOperation, error in
            }
            
        )
        
        
        
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
                
               /* var CurrentDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH.mm.ss"
                let CurrentTime:String = formatter.string(from: CurrentDate)
                print(CurrentTime);
                CurrentDate = Date()+7200
                let toTime:String = formatter.string(from: CurrentDate)
                print(toTime);*/
                
                //and arrival_time between
                
                
                let getBusStop = "select shapes.shape_id, shapes.shape_pt_lat, shapes.shape_pt_lon, shapes.shape_pt_sequence from shapes INNER JOIN trips on trips.shape_id = shapes.shape_id  where trips.trip_id = '\(objroute.strBusName)'  order by shapes.shape_pt_sequence"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                
                while (resultSet.next()==true)
                {
                    let objPath = clspath();
                    var dict:Dictionary = resultSet.resultDictionary()
                    objPath.ishape_id = dict["shape_id"] as! Int
                    objPath.dshape_pt_lat = dict["shape_pt_lat"] as! Double
                    objPath.dshape_pt_lon = dict["shape_pt_lon"] as! Double
                    objPath.ishape_pt_sequence = dict["shape_pt_sequence"] as! Int
                    arrpath.add(objPath)
                 
                }
                
                //print(arrRouteInfo);
                mydatabase?.close();
            }
            
            
            let camera = GMSCameraPosition.camera(withLatitude:objroute.dUser_Stop_lat, longitude:objroute.dUser_Stop_lon,zoom: 13)
            
              //let frame1 = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height * 35)/100)
            mapView.camera = camera
            //mapView = GMSMapView.map(withFrame: frame1, camera: camera)
            //mapView.isMyLocationEnabled = true
            //self.view.addSubview(mapView)
            let marker = GMSMarker()
            marker.position = camera.target
            //marker.snippet = objUserSelectedBusStop.strstop_name
            //marker.icon = UIImage(named: "you_are_here.png")
            
            
           // btnbus.frame = CGRect(x: self.view.frame.size.width-80, y: ((self.view.frame.size.height * 35)/100) - 100 , width: 60, height: 60)
            //self.view.bringSubview(toFront: btnbus)
            
            
            marker.map = mapView
            let path = GMSMutablePath()
            for objpath in arrpath
            {
                
                let location = CLLocationCoordinate2D(latitude: (objpath as! clspath).dshape_pt_lat, longitude: (objpath as! clspath).dshape_pt_lon)
                path.add(location)
            }
            
            
            let Polyline = GMSPolyline(path: path)
            Polyline.strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1);
            Polyline.strokeWidth = 2;
            Polyline.map = self.mapView;
            
        }
        //IsofflineGlobal=true
        //drewStop(isoffline: true, sequenceID: 0)
        
        GetDataFromApi(params: objroute)
        
    }
    func openDB1()
    {
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
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
                
                
                let getBusStop = "select stops.stop_id, stop_name,stop_code, stop_sequence,stop_times.arrival_time,stops.stop_lat, stops.stop_lon from stop_times INNER JOIN stops  on stop_times.stop_id = stops.stop_id  where trip_id = '\(objroute.strBusName)' order by stop_sequence"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                arrStops.removeAllObjects();
                while (resultSet.next()==true)
                {
                     var dict:Dictionary = resultSet.resultDictionary()
                    
                     let objBusStopInfo = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code:dict["stop_code"] as! Int,strstop_desc: "",strstop_name: dict["stop_name"] as! String,strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: "",istop_id: dict["stop_id"] as! Int,istop_sequence:dict["stop_sequence"] as! Int,izone_id:"",strarrival_time: dict["arrival_time"] as! String);
                         iLastSequence=objBusStopInfo.istop_sequence
                     //objBusStopInfo.istop_id = dict["stop_id"] as! Int
                     //objBusStopInfo.strstop_name = dict["stop_name"] as! String
                    //objBusStopInfo.istop_sequence = dict["stop_sequence"] as! Int
                    //objBusStopInfo.strarrival_time = dict["arrival_time"] as! String
                    
                    
                    
                    
                    
                    arrStops.add(objBusStopInfo)
                    
                }
                
                //print(arrRouteInfo);
                mydatabase?.close();
            }
        }
        if IsRefreshON==true
        {
            if IsofflineGlobal==false
            {
                openDB()
            }
            
            IsRefreshON=false
            //drewStop(isoffline: IsofflineGlobal, sequenceID: 0)
            GetDataFromApi(params: objroute)
        }
        else
        {
        openDB()
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
        
        return arrStops.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleRoute")as! ScheduleRouteTableViewCell;
        let objbusStop:clsBusStopInfo=arrStops[indexPath.row] as! clsBusStopInfo;
        
        if objbusStop.izone_id=="2"
        {
            cell.backgroundColor=UIColor.white
            cell.viwlineBackground.backgroundColor=UIColor.white
            cell.imgCircle.image = UIImage(named: "stop_circle_blue_ico.png");
            cell.viwline.backgroundColor = UIColor(red: 57/255, green: 186/255, blue: 236/255, alpha: 1)
            cell.lblTime.textColor = UIColor(red: 57/255, green: 186/255, blue: 236/255, alpha: 1)
            cell.lblStationName.textColor = UIColor(red: 57/255, green: 186/255, blue: 236/255, alpha: 1)
            cell.btnAlarm.isHidden = true;
        }
       else if objbusStop.izone_id=="3"
        {
            cell.backgroundColor=UIColor(red: 242/255, green: 189/255, blue: 48/255, alpha: 1)
            cell.viwlineBackground.backgroundColor=UIColor(red: 242/255, green: 189/255, blue: 48/255, alpha: 1)
            cell.imgCircle.image = UIImage(named: "stop_circle_filled_ico.png");
            cell.viwline.backgroundColor = UIColor(red: 238/255, green: 40/255, blue: 39/255, alpha: 1)
            cell.lblTime.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.lblStationName.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            cell.btnAlarm.isHidden = true;
            
        }
        else
        {
            cell.backgroundColor=UIColor.white
            cell.viwlineBackground.backgroundColor=UIColor.white
            cell.imgCircle.image = UIImage(named: "stop_circle_ico.png");
            cell.viwline.backgroundColor = UIColor(red: 238/255, green: 40/255, blue: 39/255, alpha: 1)
            cell.lblStationName.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            if IsofflineGlobal==true
            {
             cell.lblTime.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            }
            else
            {
             cell.lblTime.textColor = UIColor.red
            }
            
            cell.btnAlarm.isHidden = false;
        }
        
        
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
        cell.btnViewSchedule.layer.cornerRadius = 10
        cell.btnViewSchedule.layer.borderWidth = 1
        cell.btnViewSchedule.layer.borderColor = UIColor.clear.cgColor
        cell.btnAlarm.tag=indexPath.row
        cell.btnViewSchedule.tag=indexPath.row
        
        
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       /* let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RouteStopViewController") as! RouteStopViewController
        vc.arrStops = arrStops
        vc.objroute = objroute as clsRoute
       // vc.row = indexPath.row;
        vc.objbusStop=arrStops[indexPath.row] as! clsBusStopInfo
        navigationController?.pushViewController(vc,animated: true)*/
        
    }
    
    @IBAction func btnAperamPressed(_ sender: UIButton)
    {
        var isfound:Bool = false
         let objbusStop:clsBusStopInfo=arrStops.object(at: sender.tag) as! clsBusStopInfo;
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
    @IBAction func btnviewshedulepressed(_ sender: UIButton)
    {
        let backItem = UIBarButtonItem()
        backItem.title = " "
         navigationItem.backBarButtonItem = backItem
        print("sender.tag",sender.tag);
         let objbusStop:clsBusStopInfo=arrStops[sender.tag] as! clsBusStopInfo;
       // let objbusStop:clsBusStopInfo=arrStops.object(at: sender.tag) as! clsBusStopInfo;
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RouteStopViewController") as! RouteStopViewController
        vc.arrStops = arrStops
        vc.objroute = objroute as clsRoute
        vc.objbusStop=objbusStop;
        navigationController?.pushViewController(vc,animated: true)
        
    }
    
    func drewStop(isoffline:Bool,sequenceID:Int)
    {
        
        var isCurrent:Bool=true;
         var row:Int=0
        for objBusStopInfo in arrStops
        {
            
             let objBusStopInfo1 = objBusStopInfo as! clsBusStopInfo
           // let objCategory = GrivanceCategory()
            let camera1 = GMSCameraPosition.camera(withLatitude:objBusStopInfo1.dstop_lat, longitude:objBusStopInfo1.dstop_lon,zoom: 15)
            let markerNextStop = GMSMarker()
            markerNextStop.position = camera1.target
            markerNextStop.snippet = objBusStopInfo1.strstop_name
            
            let customInfoWindow = Bundle.main.loadNibNamed("mapMarker", owner: self, options: nil)?[0] as! mapMarker
            
            customInfoWindow.lblstopnumberone.text = ""
            
            
            if isoffline==true
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss" //Your date format
                let date = dateFormatter.date(from: objBusStopInfo1.strarrival_time as! String)! //according to date format your date string
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
                
                if TimeDifference == 2
                {
                    customInfoWindow.imgBackground.image = UIImage(named: "location_ico2.png");
                    objBusStopInfo1.izone_id="2"
                     row = row+1
                }
                else
                {
                    if isCurrent==true
                    {
                        isCurrent = false
                        customInfoWindow.imgBackground.image = UIImage(named: "location_ico3.png");
                        objBusStopInfo1.izone_id="3"
                    }
                    else
                    {
                        customInfoWindow.imgBackground.image = UIImage(named: "location_ico1.png");
                        objBusStopInfo1.izone_id="1"
                    }
                    
                
                    
                    
                }
                
            }
            else
            {
            
                if ( objBusStopInfo1.istop_sequence < sequenceID)
                {
                    customInfoWindow.imgBackground.image = UIImage(named: "location_ico2.png");
                    objBusStopInfo1.izone_id="2"
                    row = row+1
                }
                else
                {
                
                    if isCurrent==true
                    {
                        isCurrent = false
                        customInfoWindow.imgBackground.image = UIImage(named: "location_ico3.png");
                        objBusStopInfo1.izone_id = "3"
                    }
                    else
                    {
                        customInfoWindow.imgBackground.image = UIImage(named: "location_ico1.png");
                        objBusStopInfo1.izone_id="1"
                    }
                }
            }
            UIGraphicsBeginImageContextWithOptions(customInfoWindow.frame.size, false, 0.0)
            customInfoWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            markerNextStop.icon = image
            markerNextStop.map = mapView
            markerNextStop.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
            
        }
        
        tblBusList.reloadData()
        
        let indexPath = IndexPath(row: row , section: 0)
        print("row11",row)
       tblBusList.scrollToRow(at: indexPath, at: .middle , animated: false)
        //tblBusList.setContentOffset(<#T##contentOffset: CGPoint##CGPoint#>, animated: true)
        
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
    
    
    func GetDataFromApi(params:clsRoute)
    {
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
         var row:Int = 0
        //let url = URL(string: "http://115.124.127.89:8152/api/User")
        let strBaseUrl="http://app.pmpml.org.in:8080/pmpmlrealtime/tripupdates/"
        let strUrl = strBaseUrl+params.strBusName
        let urlwithPercentEscapes = strUrl.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        // var arrResult:Array=[clsCountry]();
        print(urlwithPercentEscapes!)
        // var response1:NSDictionary?;
        
        manager.get(urlwithPercentEscapes!, parameters: nil, progress: nil, success:
            {
                requestOperation, response in
                if response != nil
                {
                    var response1 = Dictionary<String, Any>()
                    response1 = response as! Dictionary
                    //print(response1)
                    let strtripId:String=response1["tripId"] as! String
                    var countryData:Array=[Dictionary<String, Any>()]
                    countryData=response1["tripStopList"] as! Array
                    
                    for item in countryData
                    {
                        
                        
                        let dict = item as NSDictionary
                        
                        
                        for objbusstop in self.arrStops
                        {
                            let objstopinfo = objbusstop as! clsBusStopInfo
                            if(dict["stopId"] as! String  == String(objstopinfo.istop_code))
                            {
                                let arrivaleTime:Int = dict["arrivaleTime"] as! Int
                                
                                
                                let epocTime = TimeInterval(arrivaleTime) / 1000
                                
                                let epocDate = Date(timeIntervalSince1970:  epocTime)   // "Apr 16, 2015, 2:40 AM"
                                print("Converted Time \(epocDate)")
                                
                                
                                let dateformattor = DateFormatter()
                                dateformattor.dateFormat = "HH:mm:ss"
                                dateformattor.timeZone = NSTimeZone.init(abbreviation: "GMT") as TimeZone!
                                let strGMTDate = dateformattor.string(from: epocDate as Date)
                                
                                let dtISTDate = dateformattor.date(from: strGMTDate as String)
                                
                                dateformattor.timeZone = NSTimeZone.init(abbreviation: "IST") as TimeZone!
                                print( dateformattor.string(from: dtISTDate!))
                                
                                //print(dtISTDate as Any )
                                objstopinfo.strarrival_time = dateformattor.string(from: dtISTDate!);
                                break
                            }
                        }
                        
                        
                        
                        
                    }
                    //countryData=response1["Data"] as! Array
                    self.tblBusList.reloadData()
                   
                    
                    self.GetDatavahicalUpdate(params:self.objroute)
                    
                }
                else
                {
                    
                    self.IsofflineGlobal=true
                    self.drewStop(isoffline: true, sequenceID: 0)
                   
                   /*  let path: NSString = Bundle.main.path(forResource: "trip_update", ofType: "json")! as NSString
                     let data : NSData = try! NSData(contentsOfFile: path as String, options: NSData.ReadingOptions.dataReadingMapped)
                     let response1: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                     let strtripId:String=response1["tripId"] as! String
                     var countryData:Array=[Dictionary<String, Any>()]
                     countryData=response1["tripStopList"] as! Array
                     
                     for item in countryData
                     {
                     
                     
                        let dict = item as NSDictionary
                        
                        
                        for objbusstop in self.arrStops
                        {
                            let objstopinfo = objbusstop as! clsBusStopInfo
                             if(dict["stopId"] as! String  == String(objstopinfo.istop_code))
                            {
                                let arrivaleTime:Int = dict["arrivaleTime"] as! Int
                                
                            
                            let epocTime = TimeInterval(arrivaleTime) / 1000
                            
                            let epocDate = Date(timeIntervalSince1970:  epocTime)   // "Apr 16, 2015, 2:40 AM"
                            print("Converted Time \(epocDate)")
                            
                            
                            let dateformattor = DateFormatter()
                            dateformattor.dateFormat = "HH:mm:ss"
                            dateformattor.timeZone = NSTimeZone.init(abbreviation: "GMT") as TimeZone!
                            let strGMTDate = dateformattor.string(from: epocDate as Date)
                            
                            let dtISTDate = dateformattor.date(from: strGMTDate as String)
                            
                            dateformattor.timeZone = NSTimeZone.init(abbreviation: "IST") as TimeZone!
                            print( dateformattor.string(from: dtISTDate!))
                           
                            print(dtISTDate as Any )
                            objstopinfo.strarrival_time = dateformattor.string(from: dtISTDate!);
                            break
                        }
                        }
                        

 
                    
                }*/
                
                
                     //print("row13",self.row)
     // self.GetDatavahicalUpdate(params:self.objroute)
     NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
                
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.notifacationCount=0;
                
                
        },
                    failure:
            {
                
                
                requestOperation, error in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.notifacationCount=0;
                
                self.IsofflineGlobal=true
                self.drewStop(isoffline: true, sequenceID: 0)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
        }
            
        )
        
        
        
    }
    
    func RemoveSubview()
    {
        
        checkReminder();
        tblBusList.reloadData();
        
    }
    func GetDatavahicalUpdate(params:clsRoute)
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        //let url = URL(string: "http://115.124.127.89:8152/api/User")
        let strBaseUrl="http://app.pmpml.org.in:8080/pmpmlrealtime/vehicleupdates/"
        let strUrl = strBaseUrl+params.strBusName
        let urlwithPercentEscapes = strUrl.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        // var arrResult:Array=[clsCountry]();
        print(urlwithPercentEscapes!)
        // var response1:NSDictionary?;
        
        manager.get(urlwithPercentEscapes!, parameters: nil, progress: nil, success:
            {
                
                requestOperation, response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                if response != nil
                {
                    var response1 = Dictionary<String, Any>()
                    response1 = response as! Dictionary
                    /*let objApiStop = clsBusStopInfo();
                     objApiStop.istop_id = Int(response1["stopId"] as! Int)
                     objApiStop.istop_sequence = response1["stopSequence"]
                    objApiStop.dstop_lat = response1["latitude"]
                    objApiStop.dstop_lon = response1["longitude"]
                    objApiStop.strstop_desc = response1["status"]*/
                    
                    let objApiStop = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code: Int(response1["stopId"] as! String)!,strstop_desc:String(response1["status"] as! String),strstop_name: "",strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: response1["latitude"] as! Double,dstop_lon: response1["longitude"]as! Double,strIndex: "",istop_id:0,istop_sequence:Int(response1["stopSequence"] as! Int),izone_id:"",strarrival_time: "");
                    
                    self.strBusNumber = response1["vehicleId"] as! String
                    let camera = GMSCameraPosition.camera(withLatitude:objApiStop.dstop_lat, longitude:objApiStop.dstop_lon,zoom: 15)
                    self.mapView.camera = camera
                   
                    self.BusMarker.position = camera.target
                    self.BusMarker.snippet = "Bus Current Location "
                    self.BusMarker.icon = UIImage(named: "BusMarkar.png")
                    self.BusMarker.map = self.mapView
                    self.BusMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    
                    
                    
                    
     /*if((objApiStop.strstop_desc == "IN_TRANSIT_TO") && objApiStop.istop_sequence != self.iLastSequence )
     {
     objApiStop.istop_sequence = objApiStop.istop_sequence+1
     }*/
                    //countryData=response1["Data"] as! Array
                    self.tblBusList.reloadData()
                    self.IsofflineGlobal=false
                    self.drewStop(isoffline: false, sequenceID: objApiStop.istop_sequence)
                }
                else
                {
                   /*let path: NSString = Bundle.main.path(forResource: "vehicleupdates", ofType: "json")! as NSString
                    let data : NSData = try! NSData(contentsOfFile: path as String, options: NSData.ReadingOptions.dataReadingMapped)
                    let response1: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    //let objApiStop = clsBusStopInfo();
                    let objApiStop = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code: Int(response1["stopId"] as! String)!,strstop_desc:String(response1["status"] as! String),strstop_name: "",strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: response1["latitude"] as! Double,dstop_lon: response1["longitude"]as! Double,strIndex: "",istop_id:0,istop_sequence:Int(response1["stopSequence"] as! Int),izone_id:"",strarrival_time: "");
                    
                    //objApiStop.istop_id = Int(response1["stopId"] as! Int)
                    //objApiStop.istop_sequence = response1["stopSequence"]
                    //objApiStop.dstop_lat = response1["latitude"]
                    //objApiStop.dstop_lon = response1["longitude"]
                    //objApiStop.strstop_desc = response1["status"]
                    
                     let camera = GMSCameraPosition.camera(withLatitude:objApiStop.dstop_lat, longitude:objApiStop.dstop_lon,zoom: 15)
                     self.mapView.camera = camera
                     let marker = GMSMarker()
                     marker.position = camera.target
                     marker.snippet = "Bus Current Location "
                     marker.icon = UIImage(named: "BusMarkar.png")
                     marker.map = self.mapView
                     marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                     self.mapView.selectedMarker = marker
                     
                     
     if((objApiStop.strstop_desc == "IN_TRANSIT_TO") && (objApiStop.istop_sequence != self.iLastSequence) )
     {
     objApiStop.istop_sequence = objApiStop.istop_sequence+1
     }
     
                    self.tblBusList.reloadData()
                    self.drewStop(isoffline: false, sequenceID: objApiStop.istop_sequence)
                    */
                    
                }
                
                
                
                
        },
                    failure:
            {
                
                requestOperation, error in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
        }
            
        )
        
        
        
    }
    
    
}
