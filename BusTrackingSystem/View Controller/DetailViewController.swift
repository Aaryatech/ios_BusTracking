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
class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblBusList: UITableView!
    var objBus:ClsBusData!
    var mapView: GMSMapView!
    var dobFirstLat:Double!
    var dobFirstLong:Double!
    var dobLastLat:Double!
    var dobLastLong:Double!
    @IBOutlet weak var htTableView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
       
        navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "\(objBus.strBusName)";

        let editImage   = UIImage(named: "ic_seat")!
        let searchImage = UIImage(named: "ic_star")!
        let ShareImage = UIImage(named: "ic_share")!
        
        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: nil)
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: nil)
         let ShareButton = UIBarButtonItem(image: ShareImage,  style: .plain, target: self, action: nil)
        

        navigationItem.rightBarButtonItems = [ShareButton,editButton]
        
        
        
        self.htTableView.constant=CGFloat(self.view.frame.size.height-((self.view.frame.size.width*3)/4))
       
        let frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: (self.view.frame.size.width*3)/4)
        print("&Userlatitude=\(objBus.objMaPData.DobCurrentUserlatitude)")
         print("&Userlatitude=\(objBus.objMaPData.DobCurrentUserlongitude)")
        let camera = GMSCameraPosition.camera(withLatitude:objBus.objMaPData.DobCurrentUserlatitude, longitude:objBus.objMaPData.DobCurrentUserlongitude,zoom: 15)
        //let camera = GMSCameraPosition.camera(withLatitude:20.010270, longitude:73.768433,zoom: 14)
        
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "User Current Location"
        marker.map = mapView
        var i:Int = 0;
        for route in (objBus.arrRoute)
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
        
        //view = mapView1
        
       // GetStateData(strStartlat: 20.001006, strStartlong: 73.776900, strEndtlat: 20.011978, strEndlong: 73.756096)
        GetStateData(strStartlat: dobFirstLat, strStartlong: dobFirstLong, strEndtlat: dobLastLat, strEndlong: dobLastLong)
        
        // Do any additional setup after loading the view.
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
        
        let str:String = "&origin=\(strStartlat),\(strStartlong)&destination=\(strEndtlat),\(strEndlong)&mode=Transit&sensor=false&key=AIzaSyBblED4jDVgwr9u4S6rvFTvWlYcXm4_Mr8"
      
        let strUrl = "https://maps.googleapis.com/maps/api/directions/json?"+str;
        // var arrResult:Array=[clsCountry]();
        print(strUrl)
        // var response1:NSDictionary?;
        manager.get(strUrl, parameters: nil, progress: nil, success:
            {
                requestOperation, response in
                var response1 = Dictionary<String, Any>()
                response1 = response as! Dictionary
                print(response1 as Any)
                var countryData:Array=[Dictionary<String, Any>()]
                countryData=response1["routes"] as! Array
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return objBus.arrRoute.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasDetail")as! BusTableViewCell;
        let objRoute:ClsRouteDetail=objBus.arrRoute[indexPath.row];
        
        cell.lblBusNmber?.text=objRoute.strStopName;
        cell.lblBusName?.text=objRoute.strTime;
        
        
        
        
        
        return cell;
        
    }
}
