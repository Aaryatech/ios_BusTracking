//
//  DatepickerViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 22/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import JBDatePicker
protocol passDate 
{
    func RemoveSubview(date:Date)
}

class DatepickerViewController: UIViewController, JBDatePickerViewDelegate  {
    @IBOutlet weak var datePicker1: JBDatePickerView!
    var datePicker: JBDatePickerView!
    var SelectedDate = Date()
     var delegate:passDate! = nil
    @IBOutlet weak var lblMonth: UILabel!
    lazy var dateFormatter: DateFormatter = {
        
        var formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //let frameForDatePicker = CGRect(x: 25, y: (self.view.frame.size.height-250)/2, width: view.bounds.width-50, height: 250)
        //datePicker = JBDatePickerView(frame: frameForDatePicker)
        //view.addSubview(datePicker)
        datePicker1.delegate = self
        var dateToShow: Date { return Date()+1}
        // Do any additional setup after loading the view.
    }
    // MARK: - JBDatePickerViewDelegate
    func shouldAllowSelectionOfDay(_ date: Date?) -> Bool
    {
        /*let currentdate = Date()
        
        if date! < currentdate
        {
           return false
        }
        else
        {
        return true
        }
        */
        print(date!)
        return true
        /*guard let date = date else {return true}
        let comparison = NSCalendar.current.compare(date, to: Date().stripped()!, toGranularity: .day)
        
        if comparison == .orderedAscending {
            return false
        }
        return true
        */
        //this code example disables selection for dates older then today
        
        
    }
    func didSelectDay(_ dayView: JBDatePickerDayView) {
        print("date selected: \(String(describing: dayView.date))")
        SelectedDate = dayView.date!
        
       
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/YYYY"
        
        
        
        let changedate:String = formatter1.string(from: SelectedDate)
        
        
        //self.btnSelectedDate.setTitle(formatter.string(from: date),for: .normal)
        //let Date1:Date = formatter1.date(from: changedate)!
        let CurrentDate:Date = Date()
        let strDate:String = formatter1.string(from: CurrentDate);
        //let formatedDate:Date = formatter1.date(from:strDate )!
        
        if(strDate == changedate)
        {
        
        }
        
       else if SelectedDate < CurrentDate
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"select greater than current date")
            
        }
        
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView)
    {
        print("month selected: \(monthView.monthDescription)")
        lblMonth.text = monthView.monthDescription
    }
    
  
    
    var colorForWeekDaysViewBackground: UIColor {
        return UIColor(red: 252.0/255.0, green: 188.0/255.0, blue: 4.0/255.0, alpha: 1.0)

    }
    
    var colorForSelectionCircleForOtherDate: UIColor {
        return UIColor(red: 252.0/255.0, green: 188.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    }
    
    var colorForSelectionCircleForToday: UIColor {
        return UIColor(red: 252.0/255.0, green: 188.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    }
    var shouldShowMonthOutDates: Bool {
        return false
    }
    
    
    //custom weekdays view height
    var weekDaysViewHeightRatio: CGFloat {
        return 0.15
    }
    
    //custom selection shape
    var selectionShape: JBSelectionShape {
        return .roundedRect
    }
    
   
   
    
    @IBAction func btnOkPressed(_ sender: Any)
    {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/YYYY"
        
        
        
        let changedate:String = formatter1.string(from: SelectedDate)
        
        
        //self.btnSelectedDate.setTitle(formatter.string(from: date),for: .normal)
        //let Date1:Date = formatter1.date(from: changedate)!
        let CurrentDate:Date = Date()
        let strDate:String = formatter1.string(from: CurrentDate);
        //let formatedDate:Date = formatter1.date(from:strDate )!
        
        
        if(strDate == changedate)
        {
            delegate!.RemoveSubview(date: SelectedDate as Date)
            self.view!.removeFromSuperview()
            self.removeFromParentViewController()
        }
            
        else if SelectedDate < CurrentDate
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"select greater than current date")
            
        }
        else
        {
            delegate!.RemoveSubview(date: SelectedDate as Date)
            self.view!.removeFromSuperview()
            self.removeFromParentViewController()
        }
        
        
        
    }
    @IBAction func btnCamclePressed(_ sender: Any)
    {
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
   
    
}
