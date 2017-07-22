   //
//  GrivanceDetailViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 15/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//
protocol ChangeStatus
{
    func ChaneStatusReflect()
}

import UIKit
import NVActivityIndicatorView
class GrivanceDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,RatingView {
    var expandedRows = Set<Int>()
    @IBOutlet weak var tableView: UITableView!
    let arrGrivance = NSMutableArray()
    var issueId:Int = 0
    let objMygrivance = MyGrivance()
    var isChaangeStatus:Bool = false
    var delegate:ChangeStatus! = nil
    var iscommingfromBase:Bool=false
    var strurl:String = ""
    @IBOutlet weak var viwStatusview: UIView!
    @IBOutlet weak var htChangeStatus: NSLayoutConstraint!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        getIssueDetail();
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        tableView.isHidden = true;
        self.htChangeStatus.constant=0;
        self.viwStatusview.isHidden=true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        self.navigationItem.title = "Grievances Details";
        
        
        
         //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"grievance Details", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
       self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //determineMyCurrentLocation()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        if isChaangeStatus==true
        {
         self.delegate.ChaneStatusReflect()
        }
        
      else if(iscommingfromBase==true && isChaangeStatus==false)
        {
        self.delegate.ChaneStatusReflect()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //determineMyCurrentLocation()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func getIssueDetail()
    {
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        let table = appDelegate.client.table(withName: "issue")
        let query = table?.query()
        query?.parameters = ["id": issueId]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        query?.read(){
            (result ,error) in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //var issue: Issue?
            
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.view.makeToast(message: "Please check internet connection", duration: 3, position: HRToastPositionDefault as AnyObject)
            }
            else if let items = result?.items
            {
                
                for item in items
                {
                    print("Todo Item: ", item as! NSDictionary)
                    let dict1 = item as! NSDictionary
                    //let objMygrivance = MyGrivance()
                    let dict = self.nullKeyRemoval(dict: dict1 as! NSMutableDictionary)
                    self.objMygrivance.strCategoryEn = dict["CategoryEn"] as! String ;
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
                    let date:Date = (dict["createdDate"] as! Date)   //according to date format your date string
                    var newDate1 = String()
                    if dict["resolvedDate"] is String
                    {
                        newDate1=""
                    }
                    else
                    {
                        let date1:Date = (dict["resolvedDate"] as! Date)   //according to date format your
                        dateFormatter.dateFormat = "dd MMM, yyyy"
                        newDate1 = dateFormatter.string(from: date1)
                    }
                    print(date ) //
                    dateFormatter.dateFormat = "dd MMM, yyyy" //Your New Date format as per requirement change it own
                    let newDate = dateFormatter.string(from: date) //pass Date here
                    
                    print(newDate)
                    self.objMygrivance.strresolvedDate = newDate1;
                    self.objMygrivance.strcreatedDate = newDate;
                    self.objMygrivance.strdescription = dict["description"] as! String;
                    self.objMygrivance.strCategoryEn = dict["CategoryEn"] as! String;
                    self.objMygrivance.strimageName = dict["imageName"] as! String;
                    self.objMygrivance.istatus = dict["status"] as! Int;
                    self.objMygrivance.iIssueNumber = dict["IssueNumber"] as! Int;
                    self.objMygrivance.iautoRatingLevel1 = dict["autoRatingLevel1"] as! Int;
                    self.objMygrivance.iautoRatingLevel2 = dict["autoRatingLevel2"] as! Int;
                    self.objMygrivance.icategoryID = dict["categoryID"] as! Int;
                    self.objMygrivance.straddress = dict["address"] as! String;
                    if(self.objMygrivance.istatus==1)
                    {
                    self.objMygrivance.strhandlerName = dict["handlerName2"] as! String;
                        if(self.objMygrivance.strhandlerName.characters.count==0)
                        {
                        self.objMygrivance.strhandlerName = dict["handlerName"] as! String;
                          if(self.objMygrivance.strhandlerName.characters.count==0)
                          {
                            self.objMygrivance.strhandlerName = "NA"
                          }
                        }
                    }
                    else
                    {
                        self.objMygrivance.strhandlerName = dict["handlerName2"] as! String;
                    }
                    
                    
                   // self.arrGrivance.add(objMygrivance)
                    
                }
                if self.objMygrivance.istatus == 3
                {
                    self.htChangeStatus.constant=50;
                    self.viwStatusview.isHidden=false
                }
                else
                {
                 self.htChangeStatus.constant=0;
                 self.viwStatusview.isHidden=true
                }
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.tableView.reloadData();
                self.getIssueImage();
                self.tableView.isHidden = false;
            }
        }
    }
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func getIssueImage()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        let table = appDelegate.client.table(withName: "image")
        let query = table?.query()
        query?.parameters = ["issueID": issueId]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        query?.read(){
            (result ,error) in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //var issue: Issue?
            
            if let err = error {
                print("ERROR ", err)
            }
            else if let items = result?.items
            {
                print("Todo Item: ", result! )
                print("Todo Item: ", items )
                if(items.count>0)
                {
                    //let dict:Dictionary=(items[0] as! [String:Any]?)!
                    //print(dict as Any)
                    var response1 = Dictionary<String, Any>()
                    response1 = items[0] as! Dictionary
                    self.strurl = "http://fixipmpmldev.blob.core.windows.net:80/issuepics/" + (response1["url"] as! String)
                    self.tableView.reloadData();
                    
                }
                
                
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section==0
        {
            return 1;
        }
        else
        {
            if self.objMygrivance.istatus == 1
            {
                return 1;
            }
            else if self.objMygrivance.istatus == 2
            {
                return 2;
            }
            else if self.objMygrivance.istatus == 3
            {
                return 3;
            }
            else
            {
                return 4;
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0
        {
            let cell:ExpansedDetailHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ExpansedDetailHeaderTableViewCell
            let objMygrivance:MyGrivance = self.objMygrivance
            cell.lblGrivamceType.text=objMygrivance.strCategoryEn;
            
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, yyyy"
            let result = formatter.string(from: date)
            
            if result == objMygrivance.strcreatedDate
            {
                cell.lblReportedOn.text="Today";
            }
            else
            {
                cell.lblReportedOn.text=objMygrivance.strcreatedDate;
            }
            
            
            
            //cell.lblReportedOn.text=objMygrivance.strcreatedDate;
            cell.lblDescription.text=objMygrivance.strdescription;
            cell.lblAddress.text=objMygrivance.straddress
            cell.lblIssueNumber.text = String("Issue No: \(objMygrivance.iIssueNumber)")
            cell.btnnStatus.layer.cornerRadius = 12
            cell.btnnStatus.layer.borderWidth = 1
            cell.btnnStatus.layer.borderColor = UIColor.clear.cgColor
            cell.btnnStatus.isUserInteractionEnabled = false
           /* if(strurl.characters.count>0)
            {
            let url = URL(string:strurl )
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                }
            }
            }*/
            
            let url = URL(string: strurl)
            let placeholder:Image = UIImage(named: "no_image_pmpml.png")!
            cell.imgGrievance?.kf.setImage(with: url,
                                        placeholder:placeholder ,
                                        options: [.transition(ImageTransition.fade(1))],
                                        progressBlock: { receivedSize, totalSize in
                                            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                        completionHandler: { image, error, cacheType, imageURL in
                                            print("\(indexPath.row + 1): Finished")
            })
            
            if objMygrivance.istatus == 2
            {
                cell.btnnStatus.setTitle("In Progress",for: .normal)
                cell.btnnStatus.backgroundColor = UIColor(red: 235/255, green: 171/255, blue: 29/255, alpha: 1)
            }
            else if objMygrivance.istatus == 3
            {
                cell.btnnStatus.setTitle("Resolved",for: .normal)
                cell.btnnStatus.backgroundColor = UIColor(red: 36/255, green: 163/255, blue: 168/255, alpha: 1)
            }
            else if objMygrivance.istatus == 6
            {
                cell.btnnStatus.backgroundColor = UIColor(red: 34/255, green: 154/255, blue: 85/255, alpha: 1)
                cell.btnnStatus.setTitle("Closed",for: .normal)
            }
            
            let font = UIFont(name: "Helvetica", size: 15.0)
            // htGrivenceType:CGFloat = heightForView(text: cell.lblGrivamceType.text, font: font, width: self.view.size)
            cell.isExpanded = self.expandedRows.contains(indexPath.row)
            return cell
        }
        else
        {
            let cell:ExpandabelFooterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellFooter") as! ExpandabelFooterTableViewCell
            let objMygrivance:MyGrivance = self.objMygrivance
            
            
            cell.lblDescription.text=objMygrivance.strhandlerName;
            cell.lblIssueNumber.text = String("Issue No: \(objMygrivance.iIssueNumber)")
            cell.btnnStatus.layer.cornerRadius = 12
            cell.btnnStatus.layer.borderWidth = 1
            cell.btnnStatus.layer.borderColor = UIColor.clear.cgColor
            
            
            if objMygrivance.istatus == 1
            {
                cell.btnnStatus.setTitle("Assigned",for: .normal)
                cell.btnnStatus.backgroundColor = UIColor(red: 243/255, green: 108/255, blue: 87/255, alpha: 1)
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM, yyyy"
                let result = formatter.string(from: date)
                
                if result == objMygrivance.strcreatedDate
                {
                    cell.lblReportedOn.text="Today";
                }
                else
                {
                    cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                }
                //cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                cell.imgCorrect.isHidden = true
                cell.viwCorrectLine.isHidden = true
                cell.leadingLowerview.constant = 10
                cell.leadingupperview.constant = 10
                
            }
           else if objMygrivance.istatus == 2
            {
                if indexPath.row==0
                {
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = false
                    cell.btnnStatus.setTitle("In Progress",for: .normal)
                    cell.btnnStatus.backgroundColor =  UIColor(red: 235/255, green: 171/255, blue: 29/255, alpha: 1)
                    
                    cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                }
                else
                {
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = true
                    cell.btnnStatus.setTitle("Assigned",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 243/255, green: 108/255, blue: 87/255, alpha: 1)
                    cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                }
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM, yyyy"
                let result = formatter.string(from: date)
                
                if result == objMygrivance.strcreatedDate
                {
                    cell.lblReportedOn.text="Today";
                }
                else
                {
                    cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                }
                
            }
            else if objMygrivance.istatus == 3
            {
                if indexPath.row==0
                {
                    cell.btnnStatus.setTitle("Resolved",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 36/255, green: 163/255, blue: 168/255, alpha: 1)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strresolvedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strresolvedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strresolvedDate;
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = false
                }
              else  if indexPath.row==1
                {
                    cell.btnnStatus.setTitle("In Progress",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 235/255, green: 171/255, blue: 29/255, alpha: 1)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strcreatedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = false
                }
                else
                {
                    cell.btnnStatus.setTitle("Assigned",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 243/255, green: 108/255, blue: 87/255, alpha: 1)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strcreatedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = true
                }
                
            }
            
            else if objMygrivance.istatus == 6
            {
                if indexPath.row==0
                {
                    cell.btnnStatus.backgroundColor = UIColor(red: 34/255, green: 154/255, blue: 85/255, alpha: 1)
                    cell.btnnStatus.setTitle("Closed",for: .normal)
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strcreatedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strresolvedDate;
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = false
                }
               else if indexPath.row==1
                {
                    cell.btnnStatus.setTitle("Resolved",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 36/255, green: 163/255, blue: 168/255, alpha: 1)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strresolvedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strresolvedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strresolvedDate;
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = false
                }
                else  if indexPath.row==2
                {
                    cell.btnnStatus.setTitle("In Progress",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 235/255, green: 171/255, blue: 29/255, alpha: 1)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strcreatedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = false
                }
                else
                {
                    cell.btnnStatus.setTitle("Assigned",for: .normal)
                    cell.btnnStatus.backgroundColor = UIColor(red: 243/255, green: 108/255, blue: 87/255, alpha: 1)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, yyyy"
                    let result = formatter.string(from: date)
                    
                    if result == objMygrivance.strcreatedDate
                    {
                        cell.lblReportedOn.text="Today";
                    }
                    else
                    {
                        cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    }
                    //cell.lblReportedOn.text=objMygrivance.strcreatedDate;
                    
                    cell.imgCorrect.isHidden = false
                    cell.viwCorrectLine.isHidden = true
                }
                
            }
            
            
            
            
            
            
            
            let font = UIFont(name: "Helvetica", size: 15.0)
            // htGrivenceType:CGFloat = heightForView(text: cell.lblGrivamceType.text, font: font, width: self.view.size)
            cell.isExpanded = self.expandedRows.contains(indexPath.row)
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    // TableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section==0
        {
            
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpansedDetailHeaderTableViewCell
            else { return }
        
        /*switch cell.isExpanded
        {
        case true:
            self.expandedRows.remove(indexPath.row)
        case false:
            self.expandedRows.insert(indexPath.row)
        }*/
        
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        }
        else
        {
            guard let cell = tableView.cellForRow(at: indexPath) as? ExpandabelFooterTableViewCell
                else { return }
            
            switch cell.isExpanded
            {
            case true:
                self.expandedRows.remove(indexPath.row)
            case false:
                self.expandedRows.insert(indexPath.row)
            }
            
            
            cell.isExpanded = !cell.isExpanded
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()

        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell
            else { return }
        
        self.expandedRows.remove(indexPath.row)
        
        cell.isExpanded = false
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    /*func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?
    {
        let footerView = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 0))
        footerView.backgroundColor = UIColor.white
        
        
        if section == 1
        {
            return "Resolution Details"
        }
        else
        {
         return ""
        }
    }*/
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        
        vw.backgroundColor = UIColor(red: 224/255, green: 228/255, blue: 232/255, alpha: 1)
        
        let lbl = UILabel(frame:CGRect(x: 10, y: 0, width: vw.frame.size.width-20, height: 25))
        lbl.text = "Resolution Details"
         lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
        lbl.textColor = UIColor.lightGray
        lbl.backgroundColor  = UIColor.white
        vw.addSubview(lbl);
        
        return vw
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section==0
        {
            return 0;
        }
        return 40.0
    }
    
    
   
    func nullKeyRemoval(dict:NSMutableDictionary) -> NSMutableDictionary {
        
        for key in dict.allKeys
        {
            if (dict.object(forKey: key) is NSNull)
            {
                dict[key] = "";
            }
        }
        return dict
    }
    
    func UnSatisfactory()
    {
        let activityData = ActivityData()
       
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        let  parameters = ["issueID": issueId] as [String : Any]
        
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.client.invokeAPI("municipality/reopenIssue", body: nil, httpMethod: "put", parameters: parameters, headers: nil)
        {
            (result, response, error) -> Void in
            if let err = error {
                print("ERROR ", err)
                 self.view.makeToast(message: "Something went wrong", duration: 3, position: HRToastPositionDefault as AnyObject)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            else
            {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                //print("Todo Item: ",dict["email"]!)
              //  print("Todo Item: ",result!)
                 self.navigationController?.popViewController(animated: true)
                
                // Do something with result
            }
        }
        
        
        
        
    }
    
    @IBAction func btnSatisfactroyPressed(_ sender: Any) {
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false;
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
       let viewController = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        viewController.delegate=self;
        viewController.issueId = self.issueId
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        viewController.view.frame = view.bounds
        self.view!.addSubview(viewController.view!)
    }
    
    
    @IBAction func unSatisfactory(_ sender: Any)
    {
        UnSatisfactory();
        isChaangeStatus=true;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func RemoveRatingView(isStatusChange:Bool)
    {
        
       // self.navigationItem.leftBarButtonItem?.isEnabled = true;
        if(isStatusChange==true)
        {
        getIssueDetail();
        isChaangeStatus=true;
        }
    }

}
extension Dictionary {
    func nullKeyRemoval() -> [AnyHashable: Any] {
        var dict: [AnyHashable: Any] = self
        
        let keysToRemove = dict.keys.filter { dict[$0] is NSNull }
        let keysToCheck = dict.keys.filter({ dict[$0] is Dictionary })
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        for key in keysToCheck {
            if let valueDict = dict[key] as? [AnyHashable: Any] {
                dict.updateValue(valueDict.nullKeyRemoval(), forKey: key)
            }
        }
        return dict
    }
}
