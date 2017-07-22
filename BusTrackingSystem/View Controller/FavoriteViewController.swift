//
//  FavoriteViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 17/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var lblNoFavrute: UILabel!
    var arrLikedBusstop=NSMutableArray();
    var arrLikedRoute=NSMutableArray();
    var menuArray=NSMutableArray();
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tblBusList: UITableView!
    var databsePathStr:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        btnMenu.target=revealViewController();
        btnMenu.action=#selector(SWRevealViewController.revealToggle(_:));
        
        let objsetting = clsSetting();
        if(!objsetting.isInternetAvailable())
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
        }
        
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            
        }
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            
            
        }
        
        tblBusList.tableFooterView = UIView(frame: .zero)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let data = UserDefaults.standard.data(forKey: "likeBusStop");
        
        if (data != nil)
        {
            arrLikedBusstop = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
        }
        
        let data1 = UserDefaults.standard.data(forKey: "likedRoute");
        
        if (data1 != nil)
        {
            arrLikedRoute = (NSKeyedUnarchiver.unarchiveObject(with: data1!) as? NSMutableArray)!
        }
        
        if arrLikedRoute.count == 0 && arrLikedBusstop.count == 0
        {
            lblNoFavrute.isHidden=false;
            tblBusList.isHidden=true;
        }
        //determineMyCurrentLocation()
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
            
            if indexPath.row != 2
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
            //cell.lnlMenuItem.alpha = 0.4
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
        if indexPath.row==1
        {
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
            
            navigationController?.pushViewController(vc,animated: true)
            
        }
            
        else  if indexPath.row==0
        {
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
            
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

    
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section==0
        {
        return arrLikedBusstop.count;
        }
        else
        {
        return arrLikedRoute.count;
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section==0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikedBusstop")as! BusStopTableViewCell;
            let objBusStopInfo:clsBusStopInfo = arrLikedBusstop[indexPath.row] as! clsBusStopInfo;
            
            cell.lblStopName?.text=objBusStopInfo.strstop_name;
            cell.lblStopDescription?.text=objBusStopInfo.strstop_desc;
            
            return cell;
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikedRoute")as! RouteTableViewCell;
            let objRoute:clsRoute = arrLikedRoute[indexPath.row] as! clsRoute;
            
           /* let fullNameArr = objRoute.strBusName.components(separatedBy: "|")
            let str:String=fullNameArr[2];
            
            var fullNameArr1 = str.components(separatedBy: "to")
            
            if(fullNameArr1.count==0)
            {
                fullNameArr1 = str.components(separatedBy: "To")
            }
            if(fullNameArr1.count>1)
            {
                cell.lblRouteID?.text = fullNameArr1[1];
            }
            else
            {
                cell.lblRouteID?.text = fullNameArr1[0];
            }*/
             let strRout = GetSourceDestination(strRouteId: String(objRoute.strBusNumber), strTripId:objRoute.strBusName)
            cell.lblRouteID?.text = strRout
            cell.lblBusNumber?.text = String(objRoute.strBusNumber) ;
            
            cell.lblBusDescription?.text="";
            cell.lblArrivalTime?.text = objRoute.strarrivaltime
            cell.lblRemainingTime?.text = objRoute.strRemainingminit;
            return cell;
        }
        
        
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
        
        if indexPath.section==0
        {
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusViewController") as! BusViewController
        let objBusStopInfo:clsBusStopInfo = arrLikedBusstop[indexPath.row] as! clsBusStopInfo;
        vc.objBusStop = objBusStopInfo
       // backItem.title = objBusStopInfo.strstop_name
            backItem.title = " "
        navigationController?.pushViewController(vc,animated: true)
        }
        else
        {
        
            
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            let objRoute:clsRoute = arrLikedRoute[indexPath.row] as! clsRoute;
            
            vc.objroute = objRoute
           // vc.objUserSelectedBusStop=objBusStop
            /*let fullNameArr = objRoute.strBusName.components(separatedBy: "|")
            let str:String=fullNameArr[2];
            
            var fullNameArr1 = str.components(separatedBy: "to")
            
            if(fullNameArr1.count==0)
            {
                fullNameArr1 = str.components(separatedBy: "To")
            }
            
            if  fullNameArr.count>0
            {
                
                backItem.title = String(objRoute.strBusNumber)+"-"+fullNameArr[2];
                let objSPlitTripId = clsSPlitTripId(strType: fullNameArr[0], strRouteId: fullNameArr[1],strStrSourceAndDestination: fullNameArr[2],strStrSource: "",strStrDestination: "",strDirection: fullNameArr[3],strNumber: fullNameArr[4]);
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: objSPlitTripId)
                UserDefaults.standard.set(encodedData, forKey: "routeString")
                
                vc.title1 = fullNameArr[2];
            }
            
            */
             let strRout = GetSourceDestination(strRouteId: String(objRoute.strBusNumber), strTripId:objRoute.strBusName)
            backItem.title = String(objRoute.strBusNumber)+" - "+strRout;
            
            navigationController?.pushViewController(vc,animated: true)
            
        }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
 

}
