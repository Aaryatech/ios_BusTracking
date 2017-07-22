//
//  ReminderViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 15/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import UserNotifications
@available(iOS 10.0, *)
protocol passtodetail
{
    func RemoveSubview()
}

class ReminderViewController: UIViewController,iCarouselDelegate,iCarouselDataSource,UNUserNotificationCenterDelegate {
@IBOutlet var pickerView: iCarousel!
@IBOutlet var lblText: UILabel!
    var selected:Int=0
    let arrminits=NSMutableArray();
    let center = UNUserNotificationCenter.current()
    var objBusStopInfo:clsBusStopInfo!;
    var objroute:clsRoute!
    var delegate:passtodetail! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...60
        {
            let text = "   \(i)  "
            arrminits .add(text);
        }
        
        pickerView.reloadData()
        pickerView.type = .linear
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
       appDelegate.center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        
       appDelegate.center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AKPickerViewDataSource
    func numberOfItems(in carousel: iCarousel) -> Int {
     return   arrminits.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        
        let tempview=UIView(frame:CGRect(x: 0, y: 0, width: pickerView.frame.size.height, height: pickerView.frame.size.height))
        let frame=CGRect(x: 0, y: 0, width: pickerView.frame.size.height, height: pickerView.frame.size.height)
        let label = UILabel()
        label.frame=frame;
        if selected==index
        {
          tempview.backgroundColor = UIColor.red
           label.textColor=UIColor.white
        }
        else
        {
              tempview.backgroundColor = UIColor.clear
            label.textColor=UIColor.black
        }
        tempview.addSubview(label)
        label.textAlignment = .justified
        tempview.layer.cornerRadius = tempview.frame.height / 2
        label.text = arrminits [index] as? String  ;
        return(tempview)
        
    }

    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        selected=index
        pickerView.reloadData()
        lblText.text="minutes before arrival time at \(objBusStopInfo.strstop_name) for Bus number \(objroute.strBusNumber)"
    }
    
   /* func carouselCurrentItemIndexDidChange(_ carousel: iCarousel)
    {
        let currentindex:Int = carousel.currentItemIndex;
        selected = currentindex
        pickerView.reloadData()
    }*/
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel)
    {
        
        let currentindex:Int = carousel.currentItemIndex;
        selected = currentindex
        pickerView.reloadData()
        lblText.text="minutes before arrival time at \(objBusStopInfo.strstop_name) for Bus number \(objroute.strBusNumber)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnCreat(_ sender: Any)
    {
        let content = UNMutableNotificationContent()
        content.title = objBusStopInfo.strstop_name
        content.body = "\(objroute.strBusNumber) Number bus will come in \(selected) min on \(objBusStopInfo.strstop_name)"
        content.sound = UNNotificationSound.default()
        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        //content.userInfo
        
       var dataDict = Dictionary<String, Any>()
        let str:String = "\(objroute.strBusNumber)~\(objBusStopInfo.strstop_name)~\(objBusStopInfo.strarrival_time)"
        dataDict["route"] = str
        //dataDict["BusStopInfo"] = objBusStopInfo
        content.userInfo = dataDict
        
         let fullNameArr = objBusStopInfo.strarrival_time.components(separatedBy: ":")
        
        if fullNameArr.count==3
        {
            
       
        let date: Date = Date()
        let cal: Calendar = Calendar(identifier: .gregorian)
        
            
        let oldDate: Date = cal.date(bySettingHour: Int(fullNameArr[0])!, minute: Int(fullNameArr[1])!, second: Int(fullNameArr[2])!, of: date)!
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: -(selected), to: oldDate)
      
        
            // let date11 = Date()
            /*let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = dateFormatter.string(from: newDate!)
            print(str)
            //let triggerDate11 = dateFormatter.date(from: str);
            
            let dateFormatter11 = DateFormatter()
            dateFormatter11.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter11.timeZone = NSTimeZone(name: "IST") as TimeZone!
            let date111 = dateFormatter.date(from: str)
            let newDate333 = calendar.date(byAdding: .hour, value: Int(5.50), to: date111!)
            print(newDate333)
            // let timeinterval1:Int = 60//selected * 60;
            */
            //let date = Date(timeIntervalSinceNow: TimeInterval(timeinterval1))
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: newDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching:triggerDate,repeats: false)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval:10,repeats: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let identifier = str
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
       appDelegate.center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        
        }
        
        
        let objnotofation = clsNotificationClass(objRoute: objroute, objStopInfo: objBusStopInfo,strComapreString:str)
        let objsetting = clsSetting()
        objsetting.NotificationObject(obj: objnotofation)
        
        
        //Calendar.current.dateComponents([hour,.minute,.second,], from: date)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        delegate!.RemoveSubview()
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()

    }
    
   
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }

    @IBAction func btnCanclePressed(_ sender: AnyObject)
    {
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }
   
}
