//
//  BusViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 10/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import AFNetworking
class BusViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    var objBusStop:clsBusStopInfo!
    var databsePathStr:String = "";
    var strDestination:String="";
    var strTital:String="";
    @IBOutlet weak var tblBus: UITableView!
    @IBOutlet weak var mapView1: GMSMapView!
    //var mapView1 = GMSMapView();
    @IBOutlet  var btnbus: UIButton!
    var isCommingFrom:Int = 0
    let locationManager = CLLocationManager();
    let arrRouteInfo = NSMutableArray()
    
    //MARK: View life Cycle Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        tblBus.tableFooterView = UIView(frame: .zero)
        determineMyCurrentLocation();
        openDB()
        checkliked()
        
        
        
        
        self.title = strTital
        btnbus.layer.borderColor = UIColor.clear.cgColor
        btnbus.layer.cornerRadius = 0.5 * btnbus.bounds.size.width
        btnbus.clipsToBounds = true
        self.view.bringSubview(toFront: btnbus)
       
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBuspressed(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func checkliked()
    {
        let objsetting = clsSetting()
        let isliked:Bool=objsetting.checkBusstopIsLikeOrNot(obj: objBusStop)
        let like:UIImage
        if isliked==true
        {
            like = (UIImage(named: "favorite_yellow_ico")?.withRenderingMode(.alwaysOriginal))!
            
        }
        else
        {
            like = (UIImage(named: "favorite_ico")?.withRenderingMode(.alwaysOriginal))!
        }
        
        let RefreshImage = UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal)
        let refreshButton = UIBarButtonItem(image: RefreshImage,  style: .plain, target: self, action: #selector(refresh))
        let likeButton = UIBarButtonItem(image: like,  style: .plain, target: self, action: #selector(Like))
        navigationItem.rightBarButtonItems = [likeButton,refreshButton]
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func determineMyCurrentLocation() {
       /* if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
           */
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView1.isMyLocationEnabled = true
        //}
    }
    
    func Like(_ sender: UIButton)
    {
        let objsetting = clsSetting()
        objsetting.likedlikeBusStop(obj: objBusStop)
        checkliked();
        
    }
    func refresh(_ sender: UIButton)
    {
        mapView1.clear();
        determineMyCurrentLocation();
        openDB()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
       
        let camera = GMSCameraPosition.camera(withLatitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude,zoom: 15)
         mapView1.camera = camera
          self.view.bringSubview(toFront: btnbus)
        
         let camera1 = GMSCameraPosition.camera(withLatitude: objBusStop.dstop_lat, longitude:objBusStop.dstop_lon,zoom: 15)
        
        mapView1.camera = camera1
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.icon = UIImage(named: "you_are_here.png")
        marker.map = mapView1
        //UserCurrentLat=18.5018;
        //UserCurrentLong=73.8636;
        let markerNextStop = GMSMarker()
        markerNextStop.position = camera1.target
        markerNextStop.icon = UIImage(named: "placeholder1.png")
        markerNextStop.map = mapView1
        markerNextStop.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
        mapView1.selectedMarker = markerNextStop
        
        drawline(strStartlat: userLocation.coordinate.latitude, strStartlong: userLocation.coordinate.longitude, strEndtlat: objBusStop.dstop_lat, strEndlong: objBusStop.dstop_lon)
        locationManager.stopUpdatingLocation()
        
       
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.localizedDescription")
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
                formatter.dateFormat = "HH:mm:ss"
                let CurrentTime:String = formatter.string(from: CurrentDate)
                print(CurrentTime);
                CurrentDate = Date()+7200
                let toTime:String = formatter.string(from: CurrentDate)
                print(toTime);
                var getBusStop=""
                //and arrival_time between
                if isCommingFrom == 0
                {
                  getBusStop = "select  distinct routes.route_id, arrival_time, trips.trip_id from stop_times INNER JOIN trips ON stop_times.trip_id = trips.trip_id INNER JOIN routes ON routes.route_id = trips.route_id where stop_id =\(objBusStop.istop_id) and arrival_time between '\(CurrentTime)' and  '\(toTime)' order by arrival_time, routes.route_id"
                }
                else
                {
                getBusStop = "select  distinct routes.route_id, arrival_time, trips.trip_id from stop_times INNER JOIN trips ON stop_times.trip_id = trips.trip_id INNER JOIN routes ON routes.route_id = trips.route_id where stop_id =\(objBusStop.istop_id) and routes.route_id in (select route_id from stop_routes where stop_name = '\(strDestination)') and arrival_time between strftime('%H:%M:%S','\(CurrentTime)') and  strftime('%H:%M:%S','\(toTime)') order by arrival_time, routes.route_id"
                }
                
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                arrRouteInfo.removeAllObjects()
                while (resultSet.next()==true)
                {
                    
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss" //Your date format
                    let date = dateFormatter.date(from: dict["arrival_time"]as! String)! //according to date format your date string
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
                    
                    
                    objBusStop.strarrival_time = String(format: "%02d", min)
                    
                    var result_string = String()
                    if let result_number = dict["route_id"] as? NSNumber
                    {
                        result_string = "\(result_number)"
                        print(result_string)
                    }
                    else
                    {
                    result_string = (dict["route_id"] as! String)
                    }
                    //objRouteInfo.strRemainingminit = Remaingtime + "min";
                    
                    //let BusNumber = String(describing: dict["route_id"])
                    //print(BusNumber)
                    //let busnumber1:String! = BusNumber
                    let objRouteInfo = clsRoute(strBusNumber:  result_string , strBusDescription: "",strBusName:  dict["trip_id"] as! String,strRemainingminit: String(format: "%02d",TimeDifference) + " min",strarrivaltime: "0" ,dUser_Stop_lat:objBusStop.dstop_lat,dUser_Stop_lon:objBusStop.dstop_lon);

                    var isfound:Bool = false;
                    for objRouteInfo11 in arrRouteInfo
                    {
                        
                        
                        let objRouteInfo1:clsRoute = objRouteInfo11 as! clsRoute
                        if objRouteInfo.strBusNumber == objRouteInfo1.strBusNumber
                            {
                            isfound = true
                                break;
                            }
                        
                    }
                    
                    if isfound == false
                    {
                     arrRouteInfo.add(objRouteInfo)
                     GetDataFromApi(params: objRouteInfo)
                    }
                    /*objRouteInfo.strBusNumber = dict["route_id"] as! Int
                    objRouteInfo.strBusName = dict["trip_id"] as! String
                    objRouteInfo.strBusDescription = ""
                    objRouteInfo.strarrivaltime = dict["arrival_time"] as! String
                    
                    */
                    
                    
                    
                   
                    
                }
                
                print(arrRouteInfo);
                mydatabase?.close();
                tblBus.reloadData()
            }
        }
    }
    
    
    func dateformatter(date: Double) -> String {
        
        let date1:Date = Date() // Same you did before with timeNow variable
        let date2: Date = Date(timeIntervalSince1970: date)
        
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        print(components)
        var returnString:String = ""
        print(components.second)
        if components.second! < 60 {
            returnString = "Just Now"
        }else if components.minute! >= 1{
            returnString = String(describing: components.minute) + " min ago"
        }else if components.hour! >= 1{
            returnString = String(describing: components.hour) + " hour ago"
        }else if components.day! >= 1{
            returnString = String(describing: components.day) + " days ago"
        }else if components.month! >= 1{
            returnString = String(describing: components.month)+" month ago"
        }else if components.year! >= 1 {
            returnString = String(describing: components.year)+" year ago"
        }
        return returnString
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
                let finalhr:Int = TH*60
                TM = (finalhr - Int(CM)!) + Int(GM)!
            }
            else
            {
               TM = Int(GM)! - Int(CM)!
            }
        }
        else
        {
            TM = 0;
        }
        return TM;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48;
        
    }
    
        
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return arrRouteInfo.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Route")as! RouteTableViewCell;
        let objRoute:clsRoute = arrRouteInfo[indexPath.row] as! clsRoute;
        
       
        
        let strRout = GetSourceDestination(strRouteId: String(objRoute.strBusNumber), strTripId:objRoute.strBusName)
        cell.lblRouteID?.text = strRout;
        cell.lblBusNumber?.text = String(objRoute.strBusNumber) ;
        
        cell.lblBusDescription?.text=objRoute.strBusDescription;
       
        if(objRoute.strarrivaltime=="1")
        {
        cell.lblRemainingTime.textColor = UIColor.red
        }
        else
        {
        cell.lblRemainingTime.textColor = UIColor.black
        }
        cell.lblArrivalTime?.text = objRoute.strarrivaltime
        cell.lblRemainingTime?.text = objRoute.strRemainingminit;
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let objRoute:clsRoute = arrRouteInfo[indexPath.row] as! clsRoute;
        
        vc.objroute = objRoute
        vc.objUserSelectedBusStop=objBusStop
        let fullNameArr = objRoute.strBusName.components(separatedBy: "|")
        var str = String()
        if fullNameArr.count > 1
        {
             str = fullNameArr[2];
    
        }
        
        var fullNameArr1 = str.components(separatedBy: "to")
        
        if(fullNameArr1.count==0)
        {
        fullNameArr1 = str.components(separatedBy: "To")
        }
       
        if  fullNameArr.count>1
        {
          
            backItem.title = String(objRoute.strBusNumber)+"-"+fullNameArr[2];
        let objSPlitTripId = clsSPlitTripId(strType: fullNameArr[0], strRouteId: fullNameArr[1],strStrSourceAndDestination: fullNameArr[2],strStrSource: "",strStrDestination: "",strDirection: fullNameArr[3],strNumber: fullNameArr[4]);
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: objSPlitTripId)
            UserDefaults.standard.set(encodedData, forKey: "routeString")
        
            
        }
        
        
          let strRout = GetSourceDestination(strRouteId: String(objRoute.strBusNumber), strTripId:objRoute.strBusName)
        backItem.title = "";
        vc.title1 = String(objRoute.strBusNumber)+" - "+strRout;
        vc.strTital = String(objRoute.strBusNumber)+" - "+strRout;
        navigationController?.pushViewController(vc,animated: true)
        
    }
    
    
    
    func GetSourceDestination(strRouteId:String,strTripId:String)->String
    {
        var str = String()
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
                
               
                var diectrion:String = ""
                if strTripId.uppercased().range(of:"DOWN") != nil
                {
                    diectrion = "DOWN";
                }
                else if strTripId.uppercased().range(of:"UP") != nil
                {
                    diectrion = "UP";
                }
                else if strTripId.uppercased().range(of:"ROUND") != nil
                {
                    diectrion = "ROUND";
                }
                else
                {
                    str = "N/A"
                    return str;
                }
                
                let getBusStop = "select distinct source,destination from stop_routes  where route_id = '\(strRouteId)' and UPPER(direction) = '\(diectrion)'"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                
                while (resultSet.next()==true)
                {
                    
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                   // lblSource.text = dict["source"] as? String
                    //objBusStopInfo.istop_sequence = dict["stop_sequence"] as! Int
                    //lblDestination.text = dict["destination"] as? String
                      str = (dict["destination"] as? String)!;
                    
                    if strTripId.uppercased().range(of:dict["destination"] as! String) != nil
                    {
                        str = (dict["destination"] as? String)!;
                        break
                    }
                    
                }
                
                //print(arrRouteInfo);
                mydatabase?.close();
                
                
            }
        }
        return str;
    }
    
    
    func GetDataFromApi(params:clsRoute)
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
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
                        print("StopId",dict["stopId"]!)
                         print("StopId11",self.objBusStop.istop_code)
                    if(dict["stopId"] as! String  == String( self.objBusStop.istop_code))
                    {
                        
                        
                        //let date = NSDate(timeIntervalSince1970: TimeInterval(arrivaleTime))
                        let CurrentDate = Date()
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm:ss"
                        let CurrentTime:String = formatter.string(from: CurrentDate)
                        print(CurrentTime);
                        
                        
                        
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
                        
                        let APItime:String = dateformattor.string(from: dtISTDate!);
                        print(APItime);
                        
                        
                        
                        
                        
                        let Difference:Int = self.TimeDifference(CurrentTime: CurrentTime, GetTime: APItime)
                        
                       
                        params.strRemainingminit = String(format: "%02d",Difference) + " min"
                        params.strarrivaltime = "1"
                        break
                    }
                    }
                //countryData=response1["Data"] as! Array
                 self.tblBus.reloadData()
                 self.GetDatavahicalUpdate(params:params)
                }
                else
                {
                    /*let path: NSString = Bundle.main.path(forResource: "trip_update", ofType: "json")! as NSString
                    let data : NSData = try! NSData(contentsOfFile: path as String, options: NSData.ReadingOptions.dataReadingMapped)
                    let response1: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    let strtripId:String=response1["tripId"] as! String
                    var countryData:Array=[Dictionary<String, Any>()]
                    countryData=response1["tripStopList"] as! Array
                    
                    for item in countryData
                    {
                        
                        
                        let dict = item as NSDictionary
                        print(dict);
                        let istopid: Int = Int(dict["stopId"] as! String)!
                        
                        print(istopid);
                        //if(istopid == self.objBusStop.istop_id)
                       // {
                     let CurrentDate = Date()
                     
                     let formatter = DateFormatter()
                     formatter.dateFormat = "HH:mm:ss"
                     let CurrentTime:String = formatter.string(from: CurrentDate)
                     print(CurrentTime);
                     
                     
                     
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
                     // objstopinfo.strarrival_time = dateformattor.string(from: dtISTDate!);
                     
                     
                     
                     
                     let APItime:String = dateformattor.string(from: dtISTDate!);
                     print(APItime);
                     
                     
                     
                     
                     
                        let Difference:Int = self.TimeDifference(CurrentTime: CurrentTime, GetTime: APItime)
                        params.strRemainingminit = String(Difference) + "min"
                        params.strarrivaltime = "1"
                     
                     break
                       // }
                    }
                    //countryData=response1["Data"] as! Array
                    self.tblBus.reloadData()
                   self.GetDatavahicalUpdate(params:params)
                */
                }
                
                
                
                
                
        },
                    failure:
            {
                requestOperation, error in
                
        }
            
        )
        
        
        
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
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
                    
                    let objApiStop = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code: Int(response1["stopId"] as! String)!,strstop_desc:String(response1["vehicleId"] as! String),strstop_name: "",strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: response1["latitude"] as! Double,dstop_lon: response1["longitude"]as! Double,strIndex: "",istop_id:0,istop_sequence:Int(response1["stopSequence"] as! Int),izone_id:"",strarrival_time: "");
                    
                    
                    
                    
                    let camera = GMSCameraPosition.camera(withLatitude:objApiStop.dstop_lat, longitude:objApiStop.dstop_lon,zoom: 15)
                    self.mapView1.camera = camera
                    let marker = GMSMarker()
                    marker.position = camera.target
                    marker.snippet = "Bus Current Location "
                    marker.icon = UIImage(named: "BusMarkar.png")
                    marker.map = self.mapView1
                    marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    self.mapView1.selectedMarker = marker
                    
                    
                    params.strBusDescription = objApiStop.strstop_desc;
                    
                    self.tblBus.reloadData()
                    
                }
                else
                {
                   /*  let path: NSString = Bundle.main.path(forResource: "vehicleupdates", ofType: "json")! as NSString
                     let data : NSData = try! NSData(contentsOfFile: path as String, options: NSData.ReadingOptions.dataReadingMapped)
                     let response1: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                     
                     //let objApiStop = clsBusStopInfo();
                     let objApiStop = clsBusStopInfo(strlocation_type: "", strparent_station: "",istop_code: Int(response1["stopId"] as! String)!,strstop_desc:String(response1["vehicleId"] as! String),strstop_name: "",strstop_timezone: "",strstop_url: "",strwheelchair_boarding: "",strzone_id: "",dstop_lat: response1["latitude"] as! Double,dstop_lon: response1["longitude"]as! Double,strIndex: "",istop_id:0,istop_sequence:Int(response1["stopSequence"] as! Int),izone_id:"",strarrival_time: "");
                     
                     //objApiStop.istop_id = Int(response1["stopId"] as! Int)
                     //objApiStop.istop_sequence = response1["stopSequence"]
                     //objApiStop.dstop_lat = response1["latitude"]
                     //objApiStop.dstop_lon = response1["longitude"]
                     //objApiStop.strstop_desc = response1["status"]
                     
                    let camera = GMSCameraPosition.camera(withLatitude:objApiStop.dstop_lat, longitude:objApiStop.dstop_lon,zoom: 15)
                    self.mapView1.camera = camera
                    let marker = GMSMarker()
                    marker.position = camera.target
                    marker.snippet = "Bus Current Location "
                    marker.icon = UIImage(named: "BusMarkar.png")
                    marker.map = self.mapView1
                    marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    self.mapView1.selectedMarker = marker
                    
                    
                    params.strBusDescription = objApiStop.strstop_desc;
                    
                     self.tblBus.reloadData()
                    
                    */
                    
                }
                
                
        },
                    failure:
            {
                
                requestOperation, error in
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
        }
            
        )
        
        
        
    }
    
    
    
    
    
    func drawline(strStartlat: Double,strStartlong:Double,strEndtlat: Double,strEndlong:Double)
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        // https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626&key=YOUR_API_KEY
        
        let str:String = "&origin=\(strStartlat),\(strStartlong)&destination=\(strEndtlat),\(strEndlong)&key=AIzaSyAPTcCu-y7NALEZht39zHbhPRRmzvXBDnE&sensor=false&mode=driving"
        
        let strUrl = "https://maps.googleapis.com/maps/api/directions/json?"+str;
        
        print(strUrl)
        
        manager.get(strUrl, parameters: nil, progress: nil, success:
            {
                requestOperation, response in
                //print(response)
                var response1 = Dictionary<String, Any>()
                response1 = response as! Dictionary
                //print(response1 as Any)
                
                var countryData:Array=[Dictionary<String, Any>()]
                countryData=response1["routes"] as! Array
                
                
                if (countryData.count > 0)
                {
                    var routeDict = countryData[0];
                    var routeOverviewPolyline = Dictionary<String, Any>()
                    routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary
                    
                    let points:String = routeOverviewPolyline["points"] as! String;
                    let path = GMSMutablePath(fromEncodedPath: points)
                    
                    let polygon = GMSPolyline(path: path)
                    polygon.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1);
                    polygon.strokeWidth = 1;
                    polygon.map = self.mapView1;
                }
                
             
                
        },
                    failure:
            {
                requestOperation, error in
        }
            
        )
        
        
        
    }
    
    
    
}
