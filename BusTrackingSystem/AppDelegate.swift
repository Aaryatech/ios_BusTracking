//
//  AppDelegate.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 04/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import UserNotifications;
import NVActivityIndicatorView
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var notifacationCount:Int=0
    var client = MSClient();
     let center  = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //let backImg: UIImage = UIImage(named: "go-back.png")!
        //UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
        
        if (launchOptions != nil)
        {
            //opened from a push notification when the app is closed
         if let info = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>
         {
            if let strMatchString:String = info["route"] as! String?
            {
                
                print("Method4")
                let objSetting = clsSetting();
                let objnotification:clsNotificationClass = objSetting.RemoveNotification(strMatchString: strMatchString)
                
                //self.redirectToPage(objRoute: objnotification.objRoute, objStop: objnotification.objStopInfo)
                
                let imageDataDict:[String: AnyObject] = ["route": objnotification]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotif"), object: nil, userInfo: imageDataDict)
                
            }
            
            
          }
            
        }
        
        let datatemp = UserDefaults.standard.data(forKey: "NotificationTemp");
        var arrNoticationTemp = NSMutableArray();
        if (datatemp != nil)
        {
            arrNoticationTemp = (NSKeyedUnarchiver.unarchiveObject(with: datatemp!) as? NSMutableArray)!
            arrNoticationTemp.removeAllObjects()
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrNoticationTemp)
            UserDefaults.standard.set(encodedData, forKey: "NotificationTemp")
        }
        
        
        // Override point for customization after application launch.
        //AIzaSyBF3U5JP1BTpHixSMEhQMKgh4nN8TatFro
        NVActivityIndicatorView.DEFAULT_TYPE = .ballClipRotate
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor(red: 242/255, green: 189/255, blue: 48/255, alpha: 1)
       NVActivityIndicatorView.DEFAULT_TEXT_COLOR = UIColor(red:39/255.0, green: 57/255.0, blue: 128/255.0, alpha: 1)
        //NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "loading"
        
        setStatusBarBackgroundColor(color: UIColor.init(colorLiteralRed: 39/255.0, green: 57/255.0, blue: 128/255.0, alpha: 1))
        client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        if (UserDefaults.standard.integer(forKey: "id")>0)
        {
        
            let userID:String = UserDefaults.standard.string(forKey: "id")!
            let user = MSUser(userId: userID);
            user?.mobileServiceAuthenticationToken = UserDefaults.standard.string(forKey: "token")!
            client.currentUser = user
        }
        GMSPlacesClient.provideAPIKey("AIzaSyBF3U5JP1BTpHixSMEhQMKgh4nN8TatFro")
        GMSServices.provideAPIKey("AIzaSyBF3U5JP1BTpHixSMEhQMKgh4nN8TatFro")
        checkDataBase();
        
        UserDefaults.standard.set("", forKey: "SourceStopName")
        UserDefaults.standard.set("", forKey: "DestinationStopName")
        
        
       if #available(iOS 10.0, *) {
        center.delegate = self
        // set the type as sound or badge
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        }
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        application.registerForRemoteNotifications()
        //CopyBase();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkDataBase(){
        
        let bundlePath = Bundle.main.path(forResource: "gtfs", ofType: ".db")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("gtfs.db")
        if fileManager.fileExists(atPath: fullDestPath.path){
            print("Database file is exist")
            print(fileManager.fileExists(atPath: bundlePath!))
        }else{
            do{
                try fileManager.copyItem(atPath: (bundlePath)!, toPath: fullDestPath.path)
            }catch{
                print("\n",error)
            }
        }
        


}
    
    func CopyBase()
    {
    if let audioUrl = URL(string: "aaryatechindia.in/allconsultant/gtfs.db.zip") {
        // create your document folder url
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // your destination file url
        let destination = documentsUrl.appendingPathComponent(audioUrl.lastPathComponent)
        print(destination)
        // check if it exists before downloading it
        if FileManager().fileExists(atPath: destination.path) {
            print("The file already exists at path")
        } else {
            //  if the file doesn't exist
            //  just download the data from your url
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                // after downloading your data you need to save it to your destination url
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
                    let location = location, error == nil
                    else { return }
                do {
                    try FileManager.default.moveItem(at: location, to: destination)
                    print("file saved")
                } catch {
                    print(error)
                }
            }).resume()
        }
    }
    
 }
    
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
       
        
        if let info = notification.userInfo as? Dictionary<String,Any>
        {
            print("Method1")
            // Check if value present before using it
            if let strMatchString:String = info["route"] as! String?
            {
print("Method2")
                    let objSetting = clsSetting();
                let objnotification:clsNotificationClass = objSetting.RemoveNotification(strMatchString: strMatchString)
               self.redirectToPage(objRoute: objnotification.objRoute, objStop: objnotification.objStopInfo)
                
            }
        }
        
        
        
        
    }
    
    
    /*func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        // custom code to handle push while app is in the foreground
        print("\(notification.request.content.userInfo)")
        
        if let info = notification.request.content.userInfo as? Dictionary<String,Any>
        {
            // Check if value present before using it
            if let strMatchString:String = info["route"] as! String?
            {
                
                let objSetting = clsSetting();
                let objnotification:clsNotificationClass = objSetting.RemoveNotification(strMatchString: strMatchString)
               // self.redirectToPage(objRoute: objnotification.objRoute, objStop: objnotification.objStopInfo)
                if(objnotification != nil)
                {
                let imageDataDict:[String: AnyObject] = ["route": objnotification]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotif"), object: nil, userInfo: imageDataDict)
                }
                
            }
        }
        
    }*/
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
       print("Method3")
        if let info = response.notification.request.content.userInfo as? Dictionary<String,Any>
        {
            // Check if value present before using it
            if let strMatchString:String = info["route"] as! String?
            {
                
                print("Method4")
                let objSetting = clsSetting();
                let objnotification:clsNotificationClass = objSetting.RemoveNotification(strMatchString: strMatchString)
                
                //self.redirectToPage(objRoute: objnotification.objRoute, objStop: objnotification.objStopInfo)
                
                let imageDataDict:[String: AnyObject] = ["route": objnotification]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotif"), object: nil, userInfo: imageDataDict)
                
            }
        }
    }
    
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    
    
    
    
    
    
    
    
    func redirectToPage(objRoute:clsRoute, objStop:clsBusStopInfo)
    {
        var viewControllerToBrRedirectedTo:DetailViewController!
        
        viewControllerToBrRedirectedTo = DetailViewController() // creater specific view controller
        viewControllerToBrRedirectedTo.isCommingFrom = 1
        viewControllerToBrRedirectedTo.objroute = objRoute
        viewControllerToBrRedirectedTo.objUserSelectedBusStop = objStop
        let strRout = GetSourceDestination(strRouteId: String(objRoute.strBusNumber), strTripId:objRoute.strBusName)
        viewControllerToBrRedirectedTo.title1 = String(objRoute.strBusNumber)+" - "+strRout;
        if viewControllerToBrRedirectedTo != nil
        {
            if self.window != nil && self.window?.rootViewController != nil
            {
                let rootVC = self.window?.rootViewController!
                if rootVC is UINavigationController
                {
                    print("navigation")
                    (rootVC as! UINavigationController).pushViewController(viewControllerToBrRedirectedTo, animated: true)
                }
                else
                {
                     print("Present")
                    rootVC?.present(viewControllerToBrRedirectedTo, animated: true, completion: { () -> Void in
                        
                        
                    })
                }
                
                
            }
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

    
    
}
