//
//  ViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 04/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
var arrBus:Array=[ClsBusData]();
    @IBOutlet weak var tblBusList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bus Tracking System";
        //tblBusList.allowsSelection = false;
        tblBusList.tableFooterView = UIView(frame: .zero)
        DummyData();
        // Do any additional setup after loading the view, typically from a nib.
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
        let objBus = ClsBusData();
        objBus.strBusName="CBS to Jehan Circle"
        objBus.strBusNumber="512"
        objBus.strAvailableSeats="20"
        objBus.objMaPData=objMapData;
        objBus.arrRoute=[objRoute11,objRoute12,objRoute13];
        
        
        let objMapData1 = clsMapData();
        objMapData1.DobCurrentBuslatitude=20.001190;
        objMapData1.DobCurrentBuslongitude=73.784413;
        objMapData1.DobCurrentUserlatitude=20.004264;
        objMapData1.DobCurrentUserlongitude=73.783852;
        objMapData1.DobNextStationlatitude=20.000644;
        objMapData1.DobNextStationlongitude=73.782614;
        let objRoute21 = ClsRouteDetail();
        objRoute21.strStopName="Shalimar"
        objRoute21.strTime="12.30 PM"
        objRoute21.Doblatitude=20.000775;
        objRoute21.Doblongitude=73.785923;
        let objRoute22 = ClsRouteDetail();
        objRoute22.strStopName="CBS"
        objRoute22.strTime="12.40 PM"
        objRoute22.Doblatitude=20.000644;
        objRoute22.Doblongitude=73.782614;
        let objRoute23 = ClsRouteDetail();
        objRoute23.strStopName="Canada Corner"
        objRoute23.strTime="12.50 PM"
        objRoute23.Doblatitude=20.003023;
        objRoute23.Doblongitude=73.770469;
        let objBus2 = ClsBusData();
        objBus2.strBusName="Shalimar to Canada Corner"
        objBus2.strBusNumber="513"
        objBus2.strAvailableSeats="10"
        objBus2.objMaPData=objMapData1;
        objBus2.arrRoute=[objRoute21,objRoute22,objRoute23];
        
        
        
        let objMapData3 = clsMapData();
        objMapData3.DobCurrentBuslatitude=19.990788;
        objMapData3.DobCurrentBuslongitude=73.799121;
        objMapData3.DobCurrentUserlatitude=19.995158;
        objMapData3.DobCurrentUserlongitude=73.799809;
        objMapData3.DobNextStationlatitude=19.993734;
        objMapData3.DobNextStationlongitude=73.797250;
        let objRoute31 = ClsRouteDetail();
        objRoute31.strStopName="Nashik Road"
        objRoute31.strTime="2.30 PM"
        objRoute31.Doblatitude=19.954017;
        objRoute31.Doblongitude=73.837451;
        let objRoute32 = ClsRouteDetail();
        objRoute32.strStopName="Upnagar"
        objRoute32.strTime="2.40 PM"
        objRoute32.Doblatitude=19.993734;
        objRoute32.Doblongitude=73.837451;
        let objRoute33 = ClsRouteDetail();
        objRoute33.strStopName="Dwarka"
        objRoute33.strTime="2.50 PM"
        objRoute33.Doblatitude=19.993734;
        objRoute33.Doblongitude=73.797250;
        let objRoute34 = ClsRouteDetail();
        objRoute34.strStopName="Shalimar"
        objRoute34.strTime="3.00 PM"
        objRoute34.Doblatitude=20.000799;
        objRoute34.Doblongitude=73.785951;
        let objRoute35 = ClsRouteDetail();
        objRoute35.strStopName="CBS"
        objRoute35.strTime="3.10 PM"
        objRoute35.Doblatitude=20.000668;
        objRoute35.Doblongitude=73.782574;
        let objBus3 = ClsBusData();
        objBus3.strBusName="Nashik Road to CBS"
        objBus3.strBusNumber="514"
        objBus3.strAvailableSeats="15"
        objBus3.objMaPData=objMapData3;
        objBus3.arrRoute=[objRoute31,objRoute32,objRoute33,objRoute34,objRoute35];
        arrBus=[objBus,objBus2,objBus3];
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                   return 65;
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      
            return arrBus.count;
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusTableViewCell")as! BusTableViewCell;
        let objBus:ClsBusData=arrBus[indexPath.row];
        
            cell.lblBusNmber?.text=objBus.strBusNumber;
         cell.lblBusName?.text=objBus.strBusName;
        
        
       
        

        return cell;
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.objBus = arrBus[indexPath.row]
        navigationController?.pushViewController(vc,animated: true)
        
    }


}

