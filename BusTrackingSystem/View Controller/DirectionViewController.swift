//
//  DirectionViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 17/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import SearchTextField
import AFNetworking
import NVActivityIndicatorView
class DirectionViewController: UIViewController,UITextFieldDelegate,passtoDirectioViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

    {
    @IBOutlet weak var tblBusStopList: UITableView!
    var mapView1 :GMSMapView!
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var btnpicker: UIButton!
    
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var topContainerView: NSLayoutConstraint!
    
    var CallForOnekm:Bool = true;
    var databsePathStr:String = "";
    var SourceLat = Double()
    var SourceLon = Double()
    var DestinationLat = Double()
    var DestinationLon = Double()
    var isEdit:Int=0;
    var swiftArray: [String] = []
    var Slimit1  = CLLocationCoordinate2D();
    var Slimit2 = CLLocationCoordinate2D();
    var Slimit3 = CLLocationCoordinate2D();
    var Slimit4 = CLLocationCoordinate2D();
    var dlimit1  = CLLocationCoordinate2D();
    var dlimit2 = CLLocationCoordinate2D();
    var dlimit3 = CLLocationCoordinate2D();
    var dlimit4 = CLLocationCoordinate2D();
    
    var strSourceStopIds = String();
    var strDestinationStopIds = String();
    
    let arrSourceBusStopInfo = NSMutableArray()
    let arrDestinationBusStopInfo = NSMutableArray()
    var arrresult = NSMutableArray()
    let arrAllBusStop = NSMutableArray()
    
    @IBOutlet weak var autocompleteContainerView: UIView!
    let locationManager = CLLocationManager();
    var menuArray=NSMutableArray();
    @IBOutlet weak var htTblBusstop: NSLayoutConstraint!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var mapouterview: UIView!
    @IBOutlet weak var btnHomeKey: UIButton!
    var autoCompleteViewController: AutoCompleteViewController!
    var isFirstLoadSource: Bool = true
    var isFirstLoadDestination: Bool = true
    var textfieldon: Int = 0
    let marker = GMSMarker()
    
    //MARK: View life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
        let frame1 = CGRect(x: 0, y: 150+((self.view.frame.size.height * 11)/100), width: self.view.frame.size.width, height: self.view.frame.size.height - 150)
        let camera = GMSCameraPosition.camera(withLatitude:19.017615, longitude:72.8561644,zoom: 15)
        htTblBusstop.constant=self.view.frame.size.height - (200+frame1.size.height)
        mapView1 = GMSMapView.map(withFrame: frame1, camera: camera)
        //mapView1.isMyLocationEnabled = true
        self.view.addSubview(mapView1)
        mapView1.tag = 100
        tblBusStopList.tableFooterView = UIView(frame: .zero)
        
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
        
        
        GetAllBusStop();
       
        definesPresentationContext = true
        txtSource.delegate = self
        txtDestination.delegate = self
        
        let date = Date()
       // let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM hh:mm aa"
        // self.btnpicker.titleLabel?.text =
        self.btnpicker.setTitle("Going Now - " + formatter.string(from: date),for: .normal)

        btnHomeKey.layer.borderColor = UIColor.clear.cgColor
        btnHomeKey.layer.cornerRadius = 0.5 * btnHomeKey.bounds.size.width
        btnHomeKey.clipsToBounds = true
        btnMenu.target=revealViewController();
        btnMenu.action=#selector(SWRevealViewController.revealToggle(_:));
        
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            
        }
        
        determineMyCurrentLocation()
        
        let objsetting = clsSetting();
        if(!objsetting.isInternetAvailable())
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /*if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self,IsUsed:true)
        }*/
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        txtSource.text = UserDefaults.standard.string(forKey: "SourceStopName")
        txtDestination.text = UserDefaults.standard.string(forKey: "DestinationStopName")
        
        if ((txtSource.text == "")||(txtDestination.text == ""))
        {
            
        }
        else
        {
            
            let activityData = ActivityData()
            
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
            GetDetailBusStop(BusName: txtSource.text!, isSource: true)
            GetDetailBusStop(BusName: txtDestination.text!, isSource: false)
            
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/YYYY hh:mm aa"
            // self.btnpicker.titleLabel?.text =
            self.btnpicker.setTitle("Going Now - " + formatter.string(from: date),for: .normal)
            getresultData()
        }
    }
    
    //MARK: location Manager Delegate
    
    
    func determineMyCurrentLocation() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        locationManager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        //UserCurrentLat = userLocation.coordinate.latitude
        //UserCurrentLong = userLocation.coordinate.longitude
        
        var centre=CLLocationCoordinate2D();
        
        centre.latitude=userLocation.coordinate.latitude;
        centre.longitude=userLocation.coordinate.longitude;
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude,zoom: 15)
        mapView1.camera = camera
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.icon = UIImage(named: "you_are_here.png")
        marker.map = mapView1
        locationManager.stopUpdatingLocation()
        
        
        
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
            let Home:HomeMenu=menuArray[ indexPath.row] as! HomeMenu;
            cell.lnlMenuItem.text=Home.strMenu;
            cell.imgMenu.image = UIImage(named: Home.strImageName);
            
            if indexPath.row != 1
            {
                cell.lnlMenuItem.alpha = 0.4
                cell.imgMenu.alpha = 0.4
            }
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenu1", for: indexPath)as! HomeMenuCollectionViewCell;
            cell.imgMenu.image = UIImage(named:"nav_ico.png");
            
            cell.imgMenu.alpha = 0.4
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
        
        if indexPath.row==0
        {
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
            
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

    
    
    
    
   
    
    
        
    // MARK: - textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtSource
        {
            
            
            textfieldon=1
            //txtSource.startVisible = true
            //txtSource.filterStrings(swiftArray)
            
            if self.isFirstLoadSource {
                self.isFirstLoadSource = false
                Autocomplete.setupAutocompleteForViewcontroller(self,IsUsed:true)
            }
            
            topContainerView.constant=43;
        }
        else
        {
            textfieldon=2
            //txtDestination.startVisible = true
            //txtDestination.filterStrings(swiftArray)
            
            if self.isFirstLoadDestination {
                topContainerView.constant=100;
                self.isFirstLoadDestination = false
                Autocomplete.setupAutocompleteForViewcontroller(self,IsUsed:true)
            }
            
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Sqlite
    func GetAllBusStop()
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
                let getBusStop = "select DISTINCT stop_name from stops"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                let index:Int = 65;
                
               let arrTemp = NSMutableArray()
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                     //let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    arrTemp.add(dict["stop_name"] as! String)
                    //arrAllBusStop.add(objBusStopInfo)
                    //index=index+1
                    //print(objBusStopInfo)
                }
                
                
                print(arrAllBusStop);
                swiftArray = arrTemp.flatMap({ $0 as? String })
                
                mydatabase?.close();
            }
        }
    
    }
    
    func GetDetailBusStop(BusName:String,isSource:Bool)
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
                let getBusStop = "select * from stops where UPPER(stop_name) ='\(BusName.uppercased())'"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                let index:Int = 65;
                
                var objBusStopInfo:clsBusStopInfo!;
               
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    break;
                    
                    
                }
                
                
                
                SendAddress(isSource: isSource, Value: objBusStopInfo.strstop_name, lat:objBusStopInfo.dstop_lat, lon: objBusStopInfo.dstop_lon)
                
                
                
                mydatabase?.close();
            }
        }
        
    }
    
    func SendAddress(isSource: Bool, Value: String, lat: Double, lon: Double)
    {
        
        if isSource==true
        {
            
         UserDefaults.standard.set(Value, forKey: "SourceStopName")
         txtSource.text=Value;
         txtSource.resignFirstResponder();
            
            SourceLat=lat;
            SourceLon=lon;
            let objSetting = clsSetting()
            
            var centre=CLLocationCoordinate2D();
            
            centre.latitude=lat;
            centre.longitude=lon;
            
            if CallForOnekm == true
            {
                print("SourceLat\(lat)")
                print("SourceLon\(lon)")
                Slimit1=objSetting.locationWithBearing(bearing: 0, distanceMeters:1 * 500, origin: centre)
                print("\(Slimit1)")
                Slimit2=objSetting.locationWithBearing(bearing: 90, distanceMeters:1 * 500, origin: centre)
                print("\(Slimit2)")
                Slimit3=objSetting.locationWithBearing(bearing: 180, distanceMeters:1 * 500, origin: centre)
                print("\(Slimit3)")
                Slimit4=objSetting.locationWithBearing(bearing: 270, distanceMeters:1 * 500, origin: centre)
                print("\(Slimit4)")
                GetNearSourceBusStop();
            }
            else
            {
                print("SourceLat100\(lat)")
                print("SourceLon100\(lon)")
                Slimit1=objSetting.locationWithBearing(bearing: 0, distanceMeters:1 * 1000, origin: centre)
                print("\(Slimit1)")
                Slimit2=objSetting.locationWithBearing(bearing: 90, distanceMeters:1 * 1000, origin: centre)
                print("\(Slimit2)")
                Slimit3=objSetting.locationWithBearing(bearing: 180, distanceMeters:1 * 1000, origin: centre)
                print("\(Slimit3)")
                Slimit4=objSetting.locationWithBearing(bearing: 270, distanceMeters:1 * 1000, origin: centre)
                print("\(Slimit4)")
                GetNearSourceBusStop();
            }
            
            
        }
        else
        {
            
         UserDefaults.standard.set(Value, forKey: "DestinationStopName")
        txtDestination.text=Value;
        txtDestination.resignFirstResponder();
            DestinationLat=lat;
            DestinationLon=lon;
            
            var centre=CLLocationCoordinate2D();
            
            centre.latitude=lat;
            centre.longitude=lon;
            
            if CallForOnekm == true
            {
                print("DestinationLat\(lat)DestinationLat")
                print("DestinationLon\(lon)DestinationLon")
             let objSetting = clsSetting()
            dlimit1=objSetting.locationWithBearing(bearing: 0, distanceMeters:1 * 500, origin: centre)
            print("\(dlimit1)")
            dlimit2=objSetting.locationWithBearing(bearing: 90, distanceMeters:1 * 500, origin: centre)
            print("\(dlimit2)")
            dlimit3=objSetting.locationWithBearing(bearing: 180, distanceMeters:1 * 500, origin: centre)
            print("\(dlimit3)")
            dlimit4=objSetting.locationWithBearing(bearing: 270, distanceMeters:1 * 500, origin: centre)
            print("\(dlimit4)")
            GetNearDestinationBusStop()
            }
            else
            {
                print("DestinationLon100\(lat)lat")
                print("DestinationLon100\(lon)lot")
                let objSetting = clsSetting()
                dlimit1=objSetting.locationWithBearing(bearing: 0, distanceMeters:1 * 1000, origin: centre)
                print("\(dlimit1)")
                dlimit2=objSetting.locationWithBearing(bearing: 90, distanceMeters:1 * 1000, origin: centre)
                print("\(dlimit2)")
                dlimit3=objSetting.locationWithBearing(bearing: 180, distanceMeters:1 * 1000, origin: centre)
                print("\(dlimit3)")
                dlimit4=objSetting.locationWithBearing(bearing: 270, distanceMeters:1 * 1000, origin: centre)
                print("\(dlimit4)")
                GetNearDestinationBusStop()
            }
            
        }
        self.view.endEditing(true)
    }
    
    
    func GetNearSourceBusStop()
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
                let getBusStop = "select * from stops WHERE stop_lat >\(Slimit3.latitude) AND stop_lat<\(Slimit1.latitude) AND stop_lon<\(Slimit2.longitude) AND stop_lon>\(Slimit4.longitude)"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                var index:Int = 65;
                arrSourceBusStopInfo.removeAllObjects();
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    
                    
                    arrSourceBusStopInfo.add(objBusStopInfo)
                    index=index+1
                    print(objBusStopInfo)
                }
                
                print(arrSourceBusStopInfo);
                mydatabase?.close();
            }
        }
        
        strSourceStopIds = String();
        for objBusStop in arrSourceBusStopInfo
        {
           
            strSourceStopIds = strSourceStopIds + String((objBusStop as! clsBusStopInfo).istop_id) + ","
            
            
        }
        print("strSourceStopIds\(strSourceStopIds)");
        strSourceStopIds = strSourceStopIds.substring(to: strSourceStopIds.index(before: strSourceStopIds.endIndex))
        tblBusStopList.reloadData();
        
    }
    
    
    
    func GetNearDestinationBusStop()
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
                let getBusStop = "select * from stops WHERE stop_lat >\(dlimit3.latitude) AND stop_lat<\(dlimit1.latitude) AND stop_lon<\(dlimit2.longitude) AND stop_lon>\(dlimit4.longitude)"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                var index:Int = 65;
                arrDestinationBusStopInfo.removeAllObjects()
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    
                    /*objBusStopInfo.strlocation_type = dict["location_type"] as! String
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
                     objBusStopInfo.strIndex = String(UnicodeScalar(index)!)*/
                    
                    arrDestinationBusStopInfo.add(objBusStopInfo)
                    index=index+1
                    print(objBusStopInfo)
                }
                
                print(arrDestinationBusStopInfo);
                mydatabase?.close();
            }
        }
        //mapView.isMyLocationEnabled = true
        // let frame = CGRect(x: mapView.frame.origin.x, y: mapView.frame.origin.y, width: mapView.frame.size.width, height: mapView.frame.size.height)
        
        /* let frame1 = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: (self.view.frame.size.height * 35)/100)
         let camera = GMSCameraPosition.camera(withLatitude:SourceLat, longitude:SourceLon,zoom: 15)
         htTblBusstop.constant=self.view.frame.size.height - (200+frame1.size.height)
         mapView1 = GMSMapView.map(withFrame: frame1, camera: camera)
         //mapView1.isMyLocationEnabled = true
         self.view.addSubview(mapView1)
         
         
         marker.position = camera.target
         marker.snippet = "User Current Location"
         marker.icon = UIImage(named: "you_are_here.png")
         marker.map = mapView1
         
         */
        strDestinationStopIds = String();
        for objBusStop in arrDestinationBusStopInfo
        {
            /*let camera1 = GMSCameraPosition.camera(withLatitude:(objBusStop as! clsBusStopInfo).dstop_lat,longitude: (objBusStop as! clsBusStopInfo).dstop_lon,zoom: 15)
             let markerNextStop = GMSMarker()
             markerNextStop.position = camera1.target
             markerNextStop.snippet = (objBusStop as! clsBusStopInfo).strstop_name
             markerNextStop.icon = UIImage(named: "placeholder")
             markerNextStop.map = mapView1*/
            strDestinationStopIds = strDestinationStopIds + String((objBusStop as! clsBusStopInfo).istop_id) + ","
        }
        print("strDestinationStopIds\(strDestinationStopIds)");
        strDestinationStopIds = strDestinationStopIds.substring(to: strDestinationStopIds.index(before: strDestinationStopIds.endIndex))
        
        
    }
    
    func getresultData()
    {
        let fileManager = FileManager()
        let filepath=fileManager.urls(for:.documentDirectory,in:.userDomainMask)
        databsePathStr=filepath[0].appendingPathComponent("gtfs.db").path as String;
        
        
        
        let CurrentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm.ss"
        let CurrentTime:String = formatter.string(from: CurrentDate)
        print(CurrentTime);
        
        if fileManager.fileExists(atPath: databsePathStr as String)
        {
            let mydatabase = FMDatabase(path:databsePathStr as String)
            if mydatabase == nil
            {
                print("Database:\(mydatabase?.lastErrorMessage())")
            }
            if (mydatabase?.open())!
            {
                let getBusStop = " SELECT distinct stops.*  from stops where stop_id in(select distinct from_stop_id from stop_trips where from_stop_id in (\(strSourceStopIds)) and to_stop_id in (\(strDestinationStopIds))) order by stops.stop_id"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                var index:Int = 65;
                arrresult.removeAllObjects();
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    
                    
                    
                    let coordinateCorrentLocation = CLLocation(latitude: SourceLat, longitude: SourceLon)
                    let coordinateBusstop = CLLocation(latitude: objBusStopInfo.dstop_lat, longitude: objBusStopInfo.dstop_lon)
                    
                    let distanceInMeters = coordinateBusstop.distance(from: coordinateCorrentLocation)
                    let secdouble = distanceInMeters / 1.5;
                    let rounded:Int = Int((secdouble/60).rounded(.up))
                    objBusStopInfo.strarrival_time = String(format: "%02d", rounded)
                    
                    
                    
                    arrresult.add(objBusStopInfo)
                    index=index+1
                    print(objBusStopInfo)
                }
                
                print(arrresult);
                mydatabase?.close();
                
                let sortedFriends = self.arrresult.sorted(by: { ($0 as AnyObject).strarrival_time < ($1 as AnyObject).strarrival_time })
                self.arrresult.removeAllObjects();
                self.arrresult = (sortedFriends as NSArray).mutableCopy() as! NSMutableArray
                print(sortedFriends);
                
            }
            tblBusStopList.reloadData();
        }
        
        if arrresult.count>0
        {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
            CallForOnekm=true
            let frame1 = CGRect(x: 0, y: 0, width: self.mapouterview.frame.size.width, height:self.mapouterview.frame.size.height )
            let camera = GMSCameraPosition.camera(withLatitude:SourceLat, longitude:SourceLon,zoom: 15)
            htTblBusstop.constant=self.view.frame.size.height - (180+((self.view.frame.size.width/5)*3)+((self.view.frame.size.height * 11)/100))
            mapView1 = GMSMapView.map(withFrame: frame1, camera: camera)
            //mapView1.isMyLocationEnabled = true
            self.mapouterview.addSubview(mapView1)
            mapView1.camera = camera;
            
            marker.position = camera.target
            marker.snippet = "User Current Location"
            marker.icon = UIImage(named: "you_are_here.png")
            marker.map = mapView1
            var i:Int = 0;
            for objBusStop in arrresult
            {
                
                if(i<10)
                {
                    let camera1 = GMSCameraPosition.camera(withLatitude:(objBusStop as! clsBusStopInfo).dstop_lat,longitude: (objBusStop as! clsBusStopInfo).dstop_lon,zoom: 15)
                    let markerNextStop = GMSMarker()
                    markerNextStop.position = camera1.target
                    markerNextStop.snippet = (objBusStop as! clsBusStopInfo).strstop_name
                    (objBusStop as! clsBusStopInfo).strIndex = String(UnicodeScalar(65+i)!)
                    
                    let customInfoWindow = Bundle.main.loadNibNamed("mapMarker", owner: self, options: nil)?[0] as! mapMarker
                    
                    customInfoWindow.lblstopnumberone.text = (objBusStop as! clsBusStopInfo).strIndex
                    
                    
                    UIGraphicsBeginImageContextWithOptions(customInfoWindow.frame.size, false, 0.0)
                    customInfoWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    
                    markerNextStop.icon = image
                    markerNextStop.map = mapView1
                    markerNextStop.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    markerNextStop.accessibilityLabel = "\(i)"
                    i=i+1;
                    mapView1.selectedMarker = markerNextStop
                    
                    // GetDistanceGoogle(objBusStop: objBusStop as! clsBusStopInfo)
                    
                    
                    //markerNextStop.map = mapView1
                    
                }
                
                
                
                
                
                
                
                //strSourceStopIds = strSourceStopIds + String((objBusStop as! clsBusStopInfo).istop_id) + ","
            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
        }
        else if(arrresult.count==0 && CallForOnekm==true)
        {
            CallForOnekm=false
            GetDetailBusStop(BusName: txtSource.text!, isSource: true)
            GetDetailBusStop(BusName: txtDestination.text!, isSource: true)
            getresultData()
        }
        else
        {
            CallForOnekm=true
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"No direct connectivity is available for this route")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        
        
        
    }
    
    
// MARK: - Button Press Method
    
    @IBAction func btnHomekeyPressed(_ sender: Any)
    {
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
        
        navigationController?.pushViewController(vc,animated: true)
    }
    @IBAction func btnSourcePressed(_ sender: Any)
    {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Google_PlaceViewController") as! Google_PlaceViewController
            vc.isSource=true
            vc.delegate=self;
            navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func btnDateTimePicker(_ sender: Any)
    {
     
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 39.0/255.0, green: 57.0/255.0, blue: 128.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Select Bus Time!! "
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM hh:mm aa"
           // self.btnpicker.titleLabel?.text =
            self.btnpicker.setTitle("Going Now - " + formatter.string(from: date),for: .normal)
        }
    }
    
    @IBAction func btnDestinationPressed(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Google_PlaceViewController") as! Google_PlaceViewController
            vc.isSource=false
        vc.delegate=self;
        navigationController?.pushViewController(vc,animated: true)
    }
    
    
    
   

    @IBAction func btnGoPressed(_ sender: Any)
    {
        if(txtSource.text==txtDestination.text)
        {
            arrresult.removeAllObjects()
            tblBusStopList.reloadData();
            mapView1.clear()
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Source and Destination can't be same!!")
        }
        else
        {
        let objsetting = clsSetting();
        if(!objsetting.isInternetAvailable())
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
        }
        else
        {
        
        if (Validation() == true)
        {
            
        
        let fileManager = FileManager()
        let filepath=fileManager.urls(for:.documentDirectory,in:.userDomainMask)
        databsePathStr=filepath[0].appendingPathComponent("gtfs.db").path as String;
        
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        /*let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/YYYY"
        //let CurrentTime:Date = formatter.date(from:btnpicker.titleLabel!.text! )!
        //print(CurrentTime);
        
        let CurrentTime:Date = Date()
        formatter.dateFormat = "HH:mm:ss"
        let strSource:String = formatter.string(from: CurrentTime)
        */
        let CurrentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm.ss"
        let CurrentTime:String = formatter.string(from: CurrentDate)
        print(CurrentTime);
        
        if fileManager.fileExists(atPath: databsePathStr as String)
        {
            let mydatabase = FMDatabase(path:databsePathStr as String)
            if mydatabase == nil
            {
                print("Database:\(mydatabase?.lastErrorMessage())")
            }
            if (mydatabase?.open())!
            {
               // let getBusStop = " SELECT distinct stops.*  from stops where stop_id in(select distinct from_stop_id from stop_trips where from_stop_id in (\(strSourceStopIds)) and from_stop_arrival_time >'\(CurrentTime)' and to_stop_id in (\(strDestinationStopIds))) order by stops.stop_id"
                
                let getBusStop = " SELECT distinct stops.*  from stops where stop_id in(select distinct from_stop_id from stop_trips where from_stop_id in (\(strSourceStopIds)) and to_stop_id in (\(strDestinationStopIds))) order by stops.stop_id"
                
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                var index:Int = 65;
                arrresult.removeAllObjects();
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    
                    
                    let coordinateCorrentLocation = CLLocation(latitude: SourceLat, longitude: SourceLon)
                    let coordinateBusstop = CLLocation(latitude: objBusStopInfo.dstop_lat, longitude: objBusStopInfo.dstop_lon)
                    
                    let distanceInMeters = coordinateBusstop.distance(from: coordinateCorrentLocation)
                    let secdouble = distanceInMeters / 1.5;
                    let rounded:Int = Int((secdouble/60).rounded(.up))
                    objBusStopInfo.strarrival_time = String(format: "%02d", rounded)
                    
                    
                    
                    arrresult.add(objBusStopInfo)
                    index=index+1
                    print(objBusStopInfo)
                }
                
                print(arrresult);
                mydatabase?.close();
                
                let sortedFriends = self.arrresult.sorted(by: { ($0 as AnyObject).strarrival_time < ($1 as AnyObject).strarrival_time })
                self.arrresult.removeAllObjects();
                self.arrresult = (sortedFriends as NSArray).mutableCopy() as! NSMutableArray
                print(sortedFriends);
               
            }
            tblBusStopList.reloadData();
        }
        
        
        
        if arrresult.count>0
        {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        
         let frame1 = CGRect(x: 0, y: 0, width: self.mapouterview.frame.size.width, height:self.mapouterview.frame.size.height )
         let camera = GMSCameraPosition.camera(withLatitude:SourceLat, longitude:SourceLon,zoom: 15)
         htTblBusstop.constant=self.view.frame.size.height - (180+((self.view.frame.size.width/5)*3)+((self.view.frame.size.height * 11)/100))
         mapView1 = GMSMapView.map(withFrame: frame1, camera: camera)
         //mapView1.isMyLocationEnabled = true
         self.mapouterview.addSubview(mapView1)
         mapView1.camera = camera;
         
         marker.position = camera.target
         marker.snippet = "User Current Location"
         marker.icon = UIImage(named: "you_are_here.png")
         marker.map = mapView1
       var i:Int = 0;
         for objBusStop in arrresult
         {
            if(i<10)
            {
         let camera1 = GMSCameraPosition.camera(withLatitude:(objBusStop as! clsBusStopInfo).dstop_lat,longitude: (objBusStop as! clsBusStopInfo).dstop_lon,zoom: 15)
         let markerNextStop = GMSMarker()
         markerNextStop.position = camera1.target
         markerNextStop.snippet = (objBusStop as! clsBusStopInfo).strstop_name
         (objBusStop as! clsBusStopInfo).strIndex = String(UnicodeScalar(65+i)!)   
            
            let customInfoWindow = Bundle.main.loadNibNamed("mapMarker", owner: self, options: nil)?[0] as! mapMarker
            
            customInfoWindow.lblstopnumberone.text = (objBusStop as! clsBusStopInfo).strIndex
            
            
            UIGraphicsBeginImageContextWithOptions(customInfoWindow.frame.size, false, 0.0)
            customInfoWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            markerNextStop.icon = image
            markerNextStop.map = mapView1
            markerNextStop.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
            markerNextStop.accessibilityLabel = "\(i)"
            i=i+1;
            mapView1.selectedMarker = markerNextStop
            
            }
         
        }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
 
        }
        else if(arrresult.count==0 && CallForOnekm==true)
        {
            CallForOnekm=false
            GetDetailBusStop(BusName: txtSource.text!, isSource: true)
            GetDetailBusStop(BusName: txtDestination.text!, isSource: false)
            getresultData()
        }
        else
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"No direct connectivity is available for this route")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        
        }
        }
        }
            
       
        
    }
    
    
    
    @IBAction func btnRefreshpressed(_ sender: Any)
    {
        if (Validation()==true)
        {
          let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM hh:mm aa"
        // self.btnpicker.titleLabel?.text =
        self.btnpicker.setTitle("Going Now - " + formatter.string(from: date),for: .normal)
        getresultData()
         }
    }
    
    @IBAction func btnChangeDirection(_ sender: Any)
    {
        
        if (Validation()==true)
        {
        let tempSourceStop:String = txtSource.text!
        let tempDestinationStop:String = txtDestination.text!
        //let tempSourceStopId:String = strSourceStopIds;
        //let tempDestinationStopId:String = strDestinationStopIds;
        
        txtSource.text = tempDestinationStop
        txtDestination.text = tempSourceStop
        //strSourceStopIds = tempDestinationStopId
        //strDestinationStopIds = tempSourceStopId
        GetDetailBusStop(BusName: txtSource.text!, isSource: true)
        GetDetailBusStop(BusName: txtDestination.text!, isSource: false)
        }
        
    }
    
    // MARK: - Google Distance API
    func GetDistanceGoogle(objBusStop: clsBusStopInfo)
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        // https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626&key=YOUR_API_KEY
        
        let str:String = "units=metric&origins=\(SourceLat),\(SourceLon)&destinations=\(objBusStop.dstop_lat),\(objBusStop.dstop_lon)&key=AIzaSyAPTcCu-y7NALEZht39zHbhPRRmzvXBDnE"
        
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
                
                let strMinit = str.components(separatedBy: " ");
                if strMinit.count>0
                {
                    //let firstName: String = strMinit[0]
                    let min:Int = Int(strMinit[0])!
                    
                    objBusStop.strarrival_time = String(format: "%02d", min)
                    //objBusStop.strarrival_time = firstName
                }
                // self.arrCountry = response1["Data"] as! [clsCountry]
                
                self.tblBusStopList?.reloadData()
                
                //self.clvCountry.reloadData()
                
                let sortedFriends = self.arrresult.sorted(by: { ($0 as AnyObject).strarrival_time < ($1 as AnyObject).strarrival_time })
                self.arrresult.removeAllObjects();
                self.arrresult = (sortedFriends as NSArray).mutableCopy() as! NSMutableArray
                
                print(sortedFriends);
                
                
                let camera = GMSCameraPosition.camera(withLatitude:self.SourceLat, longitude:self.SourceLon,zoom: 15)
                self.mapView1.camera = camera;
                
                
                
                self.marker.position = camera.target
                self.marker.snippet = "User Current Location"
                self.marker.icon = UIImage(named: "you_are_here.png")
                self.marker.map = self.mapView1
                // self.mapView1.delegate = self
                var i:Int = 0;
                for objBusStop in self.arrresult
                {
                    
                    if((objBusStop as! clsBusStopInfo).strarrival_time.characters.count == 0)
                    {
                        break
                    }
                    
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
                    markerNextStop.map = self.mapView1
                    markerNextStop.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    markerNextStop.accessibilityLabel = "\(i)"
                    i=i+1;
                    //self.GetDistanceGoogle(objBusStop: objBusStop as! clsBusStopInfo)
                    self.mapView1.selectedMarker = markerNextStop
                    
                }
                
                
                
                
        },
                    failure:
            {
                requestOperation, error in
        }
            
        )
        
        
        
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
        if(arrresult.count<10)
        {
        return arrresult.count;
        }
        else
        {
        return 10;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusStop")as! BusStopTableViewCell;
        let objBusStopInfo:clsBusStopInfo = arrresult[indexPath.row] as! clsBusStopInfo;
        
        cell.lblStopName?.text=objBusStopInfo.strstop_name;
        cell.lblTimeRemaing?.text=objBusStopInfo.strarrival_time;
        cell.lblStopDescription?.text = "Towards:\(GetTowardsDirection(strStopId: objBusStopInfo.istop_id))"  ;
        
        objBusStopInfo.strstop_desc = (cell.lblStopDescription?.text)!
        cell.lblindex?.text = String(objBusStopInfo.strIndex)
        return cell;
        
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusViewController") as! BusViewController
        let objBusStopInfo:clsBusStopInfo = arrresult[indexPath.row] as! clsBusStopInfo;
        vc.objBusStop = objBusStopInfo
        vc.strDestination = txtDestination.text!
        vc.isCommingFrom = 2;
        backItem.title = ""
        vc.strTital = objBusStopInfo.strstop_name
        navigationController?.pushViewController(vc,animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
    
    
    

    func Validation() -> Bool
    {
        if (txtSource.text == "")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please select source location")
            return false;
            
        }
        else if (txtDestination.text=="")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please select destination location")
            return false;
        }
       else if(txtSource.text==txtDestination.text)
        {
            
            arrresult.removeAllObjects()
            tblBusStopList.reloadData();
            mapView1.clear()
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Source and Destination can't be same!!")
            return false;
        }
        else
        {
            return true
        }
        
    }

}


extension DirectionViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField
    {
        if textfieldon==1
        {
            return self.txtSource
        }
        else
        {
            return self.txtDestination
        }
        
    }
    func ContainerView() -> UIView {
        return self.autocompleteContainerView
    }
     func top() -> CGFloat
     {
    
        if textfieldon==1
        {
            return 140
        }
        else
        {
            return 180
        }
    }
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }
    
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        let filteredCountries = self.swiftArray.filter { (country) -> Bool in
            return country.lowercased().contains(term.lowercased())
        }
        
        let countriesAndFlags: [AutocompletableOption] = filteredCountries.map { ( country) -> AutocompleteCellData in
            var country = country
            country.replaceSubrange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalized)
            return AutocompleteCellData(text: country, image: UIImage(named: country))
            }.map( { $0 as AutocompletableOption })
        
        return countriesAndFlags
    }
    
    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    
    func didSelectItem(_ item: AutocompletableOption,indexpathrow:Int)
    {
        if textfieldon==1
        {
        self.txtSource.text = item.text
            
           GetDetailBusStop(BusName: item.text, isSource: true)
        }
        else
        {
        self.txtDestination.text = item.text
            GetDetailBusStop(BusName: item.text, isSource: false)
            
            
        }
    }
}
