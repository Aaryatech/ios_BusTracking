//
//  BusStopViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 10/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//ess 500 11000 14000
//

import UIKit
import CoreLocation
import GoogleMaps
import AFNetworking
import MessageUI
import Pulsator
class BusStopViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,SWRevealViewControllerDelegate ,MFMessageComposeViewControllerDelegate,URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate
    {
    
    @IBOutlet weak var clvMenu: UICollectionView!
     @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet  var mapView: GMSMapView!
    var mapView1: GMSMapView!
    @IBOutlet var tblBusStoplist: UITableView!
     @IBOutlet  var tblBusList: UITableView!
    var objBus:ClsBusData!
    let locationManager = CLLocationManager();
    @IBOutlet weak var btnsos: UIButton!
    var menuArray:Array=[HomeMenu]();
    var UserCurrentLat:Double = 0.0;
    var UserCurrentLong:Double = 0.0;
    var CallForOnekm:Bool = true;
    let pulsator = Pulsator()
    var databsePathStr:String = "";
    var limit  = CLLocationCoordinate2D();
    var limit1 = CLLocationCoordinate2D();
    var limit2 = CLLocationCoordinate2D();
    var limit3 = CLLocationCoordinate2D();
    var arrBusStopInfo = NSMutableArray()
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
     @IBOutlet var progressView: UIProgressView!
   let marker = GMSMarker()
    
    // MARK: - View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objBus = ClsBusData();
        
       
       //Top CollectionView Data
        let Home1 = HomeMenu();
        Home1.strMenu="Bus Tracker";
        Home1.strImageName="bus_stop_ico.png";
        
        let Home2 = HomeMenu();
        Home2.strMenu="Planner";
        Home2.strImageName="direction_ico.png";
        
        let Home3 = HomeMenu();
        Home3.strMenu="Favorite";
        Home3.strImageName="favorite_ico.png";
        
        let Home4 = HomeMenu();
        Home4.strMenu="Grievances";
        Home4.strImageName="grievances_ico.png";
        
       
        menuArray=[Home1,Home2,Home3,Home4];
        //let myLocation = CLLocation(latitude: 25.33, longitude: 25.33)
        
        let objsetting = clsSetting();
        if(!objsetting.isInternetAvailable())
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
        }
        
       // Testing Tool(Static Databse)
       /* UserCurrentLat=18.5018;
        UserCurrentLong=73.8636;
        var centre=CLLocationCoordinate2D();
        
        centre.latitude=UserCurrentLat;
        centre.longitude=UserCurrentLong;
        
        limit=locationWithBearing(bearing: 0, distanceMeters:1 * 500, origin: centre)
        print("\(limit)")
        limit1=locationWithBearing(bearing: 90, distanceMeters:1 * 500, origin: centre)
        print("\(limit1)")
        limit2=locationWithBearing(bearing: 180, distanceMeters:1 * 500, origin: centre)
        print("\(limit2)")
        limit3=locationWithBearing(bearing: 270, distanceMeters:1 * 500, origin: centre)
        print("\(limit3)")
        GetNearbyBusStop();
 */
        
        //revalview Controller Configration
        
        btnMenu.target=revealViewController();
        btnMenu.action=#selector(SWRevealViewController.revealToggle(_:));
        tblBusStoplist.tableFooterView = UIView(frame: .zero)
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            
        }
        
        // SOS Configration
        btnsos.layer.borderColor = UIColor.clear.cgColor
        btnsos.layer.cornerRadius = 0.5 * btnsos.bounds.size.width
        btnsos.clipsToBounds = true
        
        /*let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.duration = 0.5
        scaleAnimation.repeatCount = 30.0
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1.2;
        scaleAnimation.toValue = 0.8;
        
        btnsos.layer.add(scaleAnimation, forKey: "scale")*/
        
        
        
       
        
       
        if (UserDefaults.standard.integer(forKey: "animation")==0)
        {
        btnsos.layer.superlayer?.insertSublayer(pulsator, below: btnsos.layer)
        pulsator.start()
        pulsator.numPulse = 5
        
        pulsator.radius = 36
        pulsator.animationDuration=7;
        pulsator.pulseInterval  = 3
        pulsator.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
            UserDefaults.standard.set("1", forKey: "animation")
        }
        
        
        //for Download Databse From server
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        let url = URL(string: "http://aaryatechindia.in/allconsultant/gtfs.db.zip")!
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
        
    }
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = btnsos.layer.position
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.catchIt), name: NSNotification.Name(rawValue: "myNotif"), object: nil)
       determineMyCurrentLocation()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        clvMenu.reloadData();
    }
    
    
    
 // MARK: - Click on notification
    func catchIt(_ userInfo: Notification)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.notifacationCount == 0
        {
          
            appDelegate.notifacationCount=1;
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let noti = userInfo.userInfo?["route"] as? clsNotificationClass
            
            
            
        vc.objroute = noti?.objRoute
        vc.objUserSelectedBusStop = noti?.objStopInfo
            let strRout = GetSourceDestination(strRouteId:(noti?.objRoute.strBusNumber)!, strTripId:(noti?.objRoute.strBusName)!)
        vc.title1 = (noti?.objRoute.strBusNumber)!+" - "+strRout;
        vc.strTital = (noti?.objRoute.strBusNumber)!+" - "+strRout;
            
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func GetSourceDestination(strRouteId:String,strTripId:String)->String
    {
        var str = String()
        let fileManager = FileManager()
        let filepath=fileManager.urls(for:.documentDirectory,in:.userDomainMask)
        var databsePathStr:String=filepath[0].appendingPathComponent("gtfs.db").path as String;
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
                // if string.lowercased().range(of:"swift")
                //and arrival_time between
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
    
    
    
    
     // MARK: - Get Current Location
    
    func determineMyCurrentLocation() {
      
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
      
    }
    
    //Find lat Long of Radious
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        let trueCourse = bearing * M_PI / 180;
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(trueCourse))
        let lon2 = lon1 + atan2(sin(trueCourse) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  Current Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        UserCurrentLat = userLocation.coordinate.latitude
        UserCurrentLong = userLocation.coordinate.longitude
        
        var centre=CLLocationCoordinate2D();
        
        centre.latitude=UserCurrentLat;
        centre.longitude=UserCurrentLong;
        
        limit=locationWithBearing(bearing: 0, distanceMeters:1 * 500, origin: centre)
        print("\(limit)")
        limit1=locationWithBearing(bearing: 90, distanceMeters:1 * 500, origin: centre)
        print("\(limit1)")
        limit2=locationWithBearing(bearing: 180, distanceMeters:1 * 500, origin: centre)
        print("\(limit2)")
        limit3=locationWithBearing(bearing: 270, distanceMeters:1 * 500, origin: centre)
        print("\(limit3)")
        GetNearbyBusStop();
        
        let camera = GMSCameraPosition.camera(withLatitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude,zoom: 15)
        mapView.camera = camera
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.icon = UIImage(named: "you_are_here.png")
        marker.map = mapView
        locationManager.stopUpdatingLocation()
        
       
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }


    // MARK: - UIColletion DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section==0 {
        return menuArray.count;
        }
        else
        {
            return 1;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section==0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenu", for: indexPath)as! HomeMenuCollectionViewCell;
        let Home:HomeMenu=menuArray[ indexPath.row];
        cell.lnlMenuItem.text=Home.strMenu;
        cell.imgMenu.image = UIImage(named: Home.strImageName);
            
            if indexPath.row > 0
            {
               cell.lnlMenuItem.alpha = 0.4
                cell.imgMenu.alpha = 0.4
            }
            else
            {
                cell.lnlMenuItem.alpha = 1
                cell.imgMenu.alpha = 1
            }
        return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenu1", for: indexPath)as! HomeMenuCollectionViewCell;
            cell.imgMenu.image = UIImage(named:"nav_ico.png");
             cell.imgMenu.alpha = 0.4
            //cell.btnShow1.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
           // cell.btnShow1.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
           
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section==1
        {
             //self.navigationController?.setNavigationBarHidden(false, animated: true)
           // let revealViewController = SWRevealViewController()
            //revealViewController.rightRevealToggle(self)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
          // revealViewController.revealToggle(animated: true)
            
            self.revealViewController().rightRevealToggle(animated: true)
            

            
        }
        else
        {
        if indexPath.row==1
        {
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
            
            navigationController?.pushViewController(vc,animated: true)
            
        }
        
      else  if indexPath.row==2
        {
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
            
            navigationController?.pushViewController(vc,animated: true)
            
        }
        else  if indexPath.row==3
        {
            
         
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GrivanceBaseViewController") as! GrivanceBaseViewController
            
            navigationController?.pushViewController(vc,animated: true)
            
        }
        else  if indexPath.row==4
        {
            if let MenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
                let navController = UINavigationController(rootViewController: MenuViewController)
                navController.setViewControllers([MenuViewController], animated:true)
                self.revealViewController().setFront(navController, animated: true)
            }
            
            
            
        }
       
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        // let paddingSpace = sectionInsets.left * (3 + 1)
        //let availableWidth = view.frame.width - paddingSpace
        
        let widthPerItem = view.frame.width / 5.3
        
        return CGSize(width: widthPerItem, height:widthPerItem)
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsetsMake(topMargin, left, bottom, right);
    }
    
    // MARK: - Tableview DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(arrBusStopInfo.count<11)
        {
        return arrBusStopInfo.count;
        }
        else
        {
            return 11;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusStop")as! BusStopTableViewCell;
        let objBusStopInfo:clsBusStopInfo = arrBusStopInfo[indexPath.row] as! clsBusStopInfo;
        
        
        cell.lblStopName?.text=objBusStopInfo.strstop_name;
        cell.lblTimeRemaing?.text=objBusStopInfo.strarrival_time ;
        cell.lblStopDescription?.text="Towards:\(GetTowardsDirection(strStopId: objBusStopInfo.istop_id))"  ;
        objBusStopInfo.strstop_desc=cell.lblStopDescription.text!
        cell.lblindex?.text = String(objBusStopInfo.strIndex)
        
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objsetting = clsSetting();
        if(!objsetting.isInternetAvailable())
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
        }
        else
        {
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusViewController") as! BusViewController
         let objBusStopInfo:clsBusStopInfo = arrBusStopInfo[indexPath.row] as! clsBusStopInfo;
        vc.objBusStop = objBusStopInfo
        backItem.title = " "
        vc.strTital = objBusStopInfo.strstop_name
        navigationController?.pushViewController(vc,animated: true)
        }
    }

    
  
    
     // MARK: - Sqlite Method for get Near Bus stop
    
    func GetNearbyBusStop()
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
                let getBusStop = "select * from stops WHERE stop_lat >\(limit2.latitude) AND stop_lat<\(limit.latitude) AND stop_lon<\(limit1.longitude) AND stop_lon>\(limit3.longitude)"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                var index:Int = 65;//For Alpabate in TableView
                arrBusStopInfo.removeAllObjects()
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                   let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    
                    
                    let coordinateCorrentLocation = CLLocation(latitude: UserCurrentLat, longitude: UserCurrentLong)
                    let coordinateBusstop = CLLocation(latitude: objBusStopInfo.dstop_lat, longitude: objBusStopInfo.dstop_lon)
                    
                    let distanceInMeters = coordinateBusstop.distance(from: coordinateCorrentLocation)
                    let secdouble = distanceInMeters / 1.5;
                    let rounded:Int = Int((secdouble/60).rounded(.toNearestOrEven))
                    objBusStopInfo.strarrival_time = String(format: "%02d", rounded)
                    
                    
                    
                   arrBusStopInfo.add(objBusStopInfo)
                    index=index+1
                    print(objBusStopInfo)
                }
                
                if arrBusStopInfo.count == 0 && CallForOnekm == true //if not getting any busstop in 500 Meter
                {
                    CallForOnekm = false
                    var centre=CLLocationCoordinate2D();
                    centre.latitude=UserCurrentLat;
                    centre.longitude=UserCurrentLong;
                    
                    limit=locationWithBearing(bearing: 0, distanceMeters:1 * 1000, origin: centre)
                    print("\(limit)")
                    limit1=locationWithBearing(bearing: 90, distanceMeters:1 * 1000, origin: centre)
                    print("\(limit1)")
                    limit2=locationWithBearing(bearing: 180, distanceMeters:1 * 1000, origin: centre)
                    print("\(limit2)")
                    limit3=locationWithBearing(bearing: 270, distanceMeters:1 * 1000, origin: centre)
                    print("\(limit3)")
                    GetNearbyBusStop();
                }
                else //if not getting any busstop in 500 Meter & 1Km
                {
                    if arrBusStopInfo.count == 0
                    {
                        tblBusStoplist.isHidden = true;
                    }
                }
                
                print(arrBusStopInfo);
                
                
                //Sort Data As per Arrival Time
                let arrsorted = self.arrBusStopInfo.sorted(by: { ($0 as AnyObject).strarrival_time < ($1 as AnyObject).strarrival_time })
                self.arrBusStopInfo.removeAllObjects();
                self.arrBusStopInfo = (arrsorted as NSArray).mutableCopy() as! NSMutableArray
                
                print(arrsorted);
                
                
                // Plot Bus Stop point On Map
                var i:Int = 0;
                for objBusStop in self.arrBusStopInfo
                {
                    
                    if((objBusStop as! clsBusStopInfo).strarrival_time.characters.count == 0)
                    {
                        break
                    }
                    if(i<11)
                    {
                    let camera1 = GMSCameraPosition.camera(withLatitude:(objBusStop as! clsBusStopInfo).dstop_lat,longitude: (objBusStop as! clsBusStopInfo).dstop_lon,zoom: 15)
                    let markerNextStop = GMSMarker()
                    markerNextStop.position = camera1.target
                    markerNextStop.snippet = (objBusStop as AnyObject).strstop_name
                    (objBusStop as! clsBusStopInfo).strIndex = String(UnicodeScalar(65+i)!)
                    
                    let customInfoWindow = Bundle.main.loadNibNamed("mapMarker", owner: self, options: nil)?[0] as! mapMarker
                    
                    customInfoWindow.lblstopnumberone.text = (objBusStop as! clsBusStopInfo).strIndex
                    
                    
                    UIGraphicsBeginImageContextWithOptions(customInfoWindow.frame.size, false, 0.0)
                    customInfoWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    
                    markerNextStop.icon = image
                    markerNextStop.map = self.mapView
                    markerNextStop.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    markerNextStop.accessibilityLabel = "\(i)"
                    i=i+1;
                    //self.GetStateData(objBusStop: objBusStop as! clsBusStopInfo)
                    self.mapView.selectedMarker = markerNextStop
                    }
                    
                }
                
                
                
                
                
                mydatabase?.close();
            }
        }
        
        //Plot Current Location
        let camera = GMSCameraPosition.camera(withLatitude:UserCurrentLat, longitude:UserCurrentLong,zoom: 15)
        mapView.camera = camera;
        
        
        
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.icon = UIImage(named: "you_are_here.png")
        marker.map = mapView
        self.tblBusStoplist?.reloadData()
        
    }
    
  
    func sorterForFileIDASC(this:clsBusStopInfo, that:clsBusStopInfo) -> Bool {
        return this.strarrival_time > that.strarrival_time
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // 1
        let index:Int! = Int(marker.accessibilityLabel!)
        // 2
        let customInfoWindow = Bundle.main.loadNibNamed("mapMarker", owner: self, options: nil)?[0] as! mapMarker
        let objBusStopInfo:clsBusStopInfo = arrBusStopInfo[index] as! clsBusStopInfo;
        customInfoWindow.lblstopnumberone.text = objBusStopInfo.strIndex
        
        return customInfoWindow
    }
    
    
    func GetTowardsDirection(strStopId:Int)->String
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
                
                
                let getBusStop = "SELECT source,destination,direction FROM stop_routes where stop_id='\(strStopId)' limit 2"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                
                
                while (resultSet.next()==true)
                {
                    
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    // lblSource.text = dict["source"] as? String
                    //objBusStopInfo.istop_sequence = dict["stop_sequence"] as! Int
                    //lblDestination.text = dict["destination"] as? String
                    str = str + (dict["destination"] as? String)! + ","
                    
                    
                    
                    
                }
                str = str.substring(to: str.index(before: str.endIndex))
                //print(arrRouteInfo);
                mydatabase?.close();
                
                
            }
        }
        return str;
    }
    
    
   
    
    
    
    
    
     // MARK: - Btn SoS & Message Delegate
    
    @IBAction func btnsosPressed(_ sender: Any)
    {
        let data = UserDefaults.standard.data(forKey: "UserContact");
        var arrContactInfo = NSMutableArray()
        if (data != nil)
        {
            arrContactInfo = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
        }
        if arrContactInfo.count == 0
        {
            // lblNoFavrute.isHidden=false;
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SOSViewController") as! SOSViewController
            
            backItem.title = " "
            navigationController?.pushViewController(vc,animated: true)
        }
        else
        {
             let arrContactonly = NSMutableArray()
            for contactinfo in arrContactInfo
            {
                let ContactNumber:String = (contactinfo as! clsContactNumber).strContactNumber as String
                arrContactonly.add(ContactNumber)
            }
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "S.O.S -I need help, my location: http://maps.google.com/maps?saddr=current+location&daddr=\(UserCurrentLat),\(UserCurrentLong)"
                let Array: [String] = arrContactonly.flatMap({ $0 as? String })
                controller.recipients = Array
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
                
            }
            else
            {
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"can not able to send message")
                
            }
        }
        
        
        
       
    }
    
    func messageComposeViewController(_ didFinishWithcontroller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
       // self.view!.removeFromSuperview()
        //self.removeFromParentViewController()
    }
    
   
    //MARK: URLSessionDownloadDelegate
    // 1
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.zip"))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(path: destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
        progressView.setProgress(0.0, animated: true)
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            //let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            //viewer.delegate = self
            //viewer.presentPreview(animated: true)
        }
    }
    
    
    
}
