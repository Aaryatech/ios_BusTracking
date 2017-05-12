//
//  BusStopViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 10/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
class BusStopViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    @IBOutlet  var mapView: GMSMapView!
    var mapView1: GMSMapView!
    var objBus:ClsBusData!
    var menuArray:Array=[HomeMenu]();
    var UserCurrentLat:Double = 0.0;
    var UserCurrentLong:Double = 0.0;
    let locationManager = CLLocationManager();
    var databsePathStr:String = "";
    var limit  = CLLocationCoordinate2D();
    var limit1 = CLLocationCoordinate2D();
    var limit2 = CLLocationCoordinate2D();
    var limit3 = CLLocationCoordinate2D();
    let arrBusStopInfo = NSMutableArray()
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        objBus = ClsBusData();
        // Webservices()
        //let Home1:HomeMenu ;
        DummyData();
        let Home1 = HomeMenu();
        Home1.strMenu="Bus Stop";
        Home1.strImageName="bus_stop_ico.png";
        
        let Home2 = HomeMenu();
        Home2.strMenu="Directions";
        Home2.strImageName="direction_ico.png";
        
        let Home3 = HomeMenu();
        Home3.strMenu="Favroite";
        Home3.strImageName="favorite_ico.png";
        
        let Home4 = HomeMenu();
        Home4.strMenu="Grivances";
        Home4.strImageName="grievances_ico.png";
        
        
        menuArray=[Home1,Home2,Home3,Home4];
        //let myLocation = CLLocation(latitude: 25.33, longitude: 25.33)
        
        UserCurrentLat=18.6298;
        UserCurrentLong=73.7997;
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
        openDB();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //determineMyCurrentLocation()
    }
    func determineMyCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
           
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
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
    func DummyData() -> Void
    {
        let objMapData = clsMapData();
        objMapData.DobCurrentBuslatitude=20.007910;
        objMapData.DobCurrentBuslongitude=73.769917;
        objMapData.DobCurrentUserlatitude=20.010270;
        objMapData.DobCurrentUserlongitude=73.768433;
        objMapData.DobNextStationlatitude=20.009186;
        objMapData.DobNextStationlongitude=73.766889;
        let objRoute11 = ClsRouteDetail();
        objRoute11.strStopName="CBS"
        objRoute11.strTime="11.00 AM"
        objRoute11.Doblatitude=20.001006;
        objRoute11.Doblongitude=73.776900;
        let objRoute12 = ClsRouteDetail();
        objRoute12.strStopName="Vidya Vikas Circle"
        objRoute12.strTime="11.20 AM"
        objRoute12.Doblatitude=20.009186;
        objRoute12.Doblongitude=73.766889;
        let objRoute13 = ClsRouteDetail();
        objRoute13.strStopName="Jehan Circle"
        objRoute13.strTime="11.30 AM"
        objRoute13.Doblatitude=20.011978;
        objRoute13.Doblongitude=73.756096;
        
        objBus.strBusName="CBS to Jehan Circle"
        objBus.strBusNumber="512"
        objBus.strAvailableSeats="20"
        objBus.objMaPData=objMapData;
        objBus.arrRoute=[objRoute11,objRoute12,objRoute13];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
         locationManager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
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
        return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenu1", for: indexPath)as! HomeMenuCollectionViewCell;
            cell.imgMenu.image = UIImage(named:"nav_ico.png");
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return arrBusStopInfo.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusStop")as! BusStopTableViewCell;
        let objBusStopInfo:clsBusStopInfo = arrBusStopInfo[indexPath.row] as! clsBusStopInfo;
        
        cell.lblStopName?.text=objBusStopInfo.strstop_name;
        cell.lblTimeRemaing?.text="10";
        cell.lblStopDescription?.text=objBusStopInfo.strstop_desc;
        cell.lblindex?.text = String(objBusStopInfo.strIndex)
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusViewController") as! BusViewController
        vc.objBusStop = arrBusStopInfo [indexPath.row] as! clsBusStopInfo
        navigationController?.pushViewController(vc,animated: true)
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
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
                let getBusStop = "select * from stops WHERE stop_lat >\(limit2.latitude) AND stop_lat<\(limit.latitude) AND stop_lon<\(limit1.longitude) AND stop_lon>\(limit3.longitude)"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                var index:Int = 65;
                
                while (resultSet.next()==true)
                {
                   let objBusStopInfo = clsBusStopInfo();
                    var dict:Dictionary = resultSet.resultDictionary()
                    objBusStopInfo.strlocation_type = dict["location_type"] as! String
                    objBusStopInfo.strparent_station = dict["parent_station"] as! String
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
                    index=index+1
                }
                
                print(arrBusStopInfo);
                mydatabase?.close();
            }
        }
        //mapView.isMyLocationEnabled = true
        // let frame = CGRect(x: mapView.frame.origin.x, y: mapView.frame.origin.y, width: mapView.frame.size.width, height: mapView.frame.size.height)
        
         let frame1 = CGRect(x: 0, y: (self.view.frame.size.height * 14)/100, width: self.view.frame.size.width, height: (self.view.frame.size.height * 35)/100)
        let camera = GMSCameraPosition.camera(withLatitude:UserCurrentLat, longitude:UserCurrentLong,zoom: 15)
        
         mapView1 = GMSMapView.map(withFrame: frame1, camera: camera)
        //mapView1.isMyLocationEnabled = true
        self.view.addSubview(mapView1)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.icon = UIImage(named: "you_are_here.png")
        marker.map = mapView1
        
        
        for objBusStop in arrBusStopInfo
        {
            let camera1 = GMSCameraPosition.camera(withLatitude:(objBusStop as AnyObject).dstop_lat,longitude: (objBusStop as AnyObject).dstop_lon,zoom: 15)
            let markerNextStop = GMSMarker()
            markerNextStop.position = camera1.target
            markerNextStop.snippet = (objBusStop as AnyObject).strstop_name
            markerNextStop.icon = UIImage(named: "placeholder")
            markerNextStop.map = mapView1
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

}
