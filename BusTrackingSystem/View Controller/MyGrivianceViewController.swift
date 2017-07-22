//
//  MyGrivianceViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 14/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class MyGrivianceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,ChangeStatus {
    var expandedRows = Set<Int>()
    @IBOutlet weak var tableView: UITableView!
    var featchlimit = 50
    var featchoffset = 0
    var ShowtrackGrivance:Int=0
    
    @IBOutlet weak var htviwSearch: NSLayoutConstraint!
    @IBOutlet weak var viwSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    let arrGrivance = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if ShowtrackGrivance==0
        {
          viwSearch.isHidden = true
           
          getGrivance();
        }
        else
        {
            viwSearch.isHidden = false
            htviwSearch.constant = 40;
            txtSearch.delegate=self;
            
            txtSearch.leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let image = UIImage(named: "magnifying-glass1.png")
            imageView.image = image
            txtSearch.leftView = imageView
            
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ShowtrackGrivance != 0
        {
        //self.navigationItem.title = "Grivance Details";
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        //determineMyCurrentLocation()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
       /* let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let image = UIImage(named: "magnifying-glass1.png")
        imageView.image = image
        txtSearch.leftView = imageView */
    }
    
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if (textField.text?.characters.count == 0)
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            let image = UIImage(named: "magnifying-glass1.png")
            imageView.image = image
            txtSearch.leftView = imageView
        }
        if (textField.text?.characters.count == -1)
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let image = UIImage(named: "magnifying-glass1.png")
            imageView.image = image
            txtSearch.leftView = imageView
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        getGrivance()
        return true
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGrivance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExpandableTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ExpandableTableViewCell
        let objMygrivance:MyGrivance = arrGrivance[indexPath.row] as! MyGrivance
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
        
        cell.lblDescription.text=objMygrivance.strdescription;
        cell.btnViewDetail.tag = indexPath.row;
        cell.lblIssueNumber.text = String("Issue No: \(objMygrivance.iIssueNumber)")
        cell.btnnStatus.layer.cornerRadius = 12
        cell.btnnStatus.layer.borderWidth = 1
        cell.btnnStatus.layer.borderColor = UIColor.clear.cgColor
        cell.btnnStatus.isUserInteractionEnabled = false;
        if objMygrivance.istatus == 1
        {
            cell.btnnStatus.setTitle("Assigned",for: .normal)
            cell.btnnStatus.backgroundColor = UIColor(red: 243/255, green: 108/255, blue: 87/255, alpha: 1)
        }
       else if objMygrivance.istatus == 2
        {
        cell.btnnStatus.setTitle("In Progress",for: .normal)
         cell.btnnStatus.backgroundColor = UIColor(red: 235/255, green: 171/255, blue: 29/255, alpha: 1)
        }
       else if objMygrivance.istatus == 3
        {
        cell.btnnStatus.setTitle("Resolved",for: .normal)
         cell.btnnStatus.backgroundColor = UIColor(red: 36/255, green: 163/255, blue: 168/255, alpha: 1)
        }
        if objMygrivance.istatus == 6
        {
             cell.btnnStatus.backgroundColor = UIColor(red: 34/255, green: 154/255, blue: 85/255, alpha: 1)
            cell.btnnStatus.setTitle("Closed",for: .normal)
        }
        
        let font = UIFont(name: "Helvetica", size: 15.0)
       // htGrivenceType:CGFloat = heightForView(text: cell.lblGrivamceType.text, font: font, width: self.view.size)
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let lastRowIndex:Int = (tableView.numberOfRows(inSection: 0)) - 1;
        if (indexPath.row == lastRowIndex)
        {
            featchoffset = featchoffset + featchlimit
            getGrivance();
        }
        
    }*/
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    // TableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell
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
    
    /*func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell
            else { return }
        
        self.expandedRows.remove(indexPath.row)
        
        cell.isExpanded = false
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }*/
    
    func getGrivance()
    {
        
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let USerID = UserDefaults.standard.string(forKey: "id")!
        //let predicate1 = NSPredicate(format: "issueType == 0")
        //let predicate2 = NSPredicate(format: "userID == \(USerID)")
        //let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
        
        //let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        let table = appDelegate.client.table(withName: "issue")
        
        let query = table?.query()
        if ShowtrackGrivance==0
        {
        query?.parameters = ["issueType" : "0", "userID" : USerID, "latitude" : "0.0", "longitude" : "0.0", "sortOrder" : "desc", "sortOn" : "date", "searchText" : ""];
             htviwSearch.constant = 0;
        }
        else
        {
             htviwSearch.constant = 40;
            query?.parameters = ["issueType" : "0", "userID" : USerID, "latitude" : "0.0", "longitude" : "0.0", "sortOrder" : "desc", "sortOn" : "date", "searchText" : txtSearch.text!];
        
        }
        query?.fetchLimit =  100  ;
        query?.fetchOffset = 0;
        query?.read() {
            (result, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                
                if self.ShowtrackGrivance==0
                {
                self.view.makeToast(message: "No Records Found", duration: 3, position: HRToastPositionDefault as AnyObject)
                }
                else
                {
                self.view.makeToast(message: "Expected issue not found", duration: 3, position: HRToastPositionDefault as AnyObject)
                }
            }
            else if let items = result?.items
            {
                self.arrGrivance.removeAllObjects()
                
                for item in items
                {
                    print("Todo Item: ", item as! NSDictionary)
                    let dict = item as! NSDictionary
                    let objMygrivance = MyGrivance()
                    objMygrivance.strCategoryEn = dict["CategoryEn"] as! String ;
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
                    let date:Date = (dict["createdDate"] as! Date)   //according to date format your date string
                    print(date ) //
                    dateFormatter.dateFormat = "dd MMM, yyyy" //Your New Date format as per requirement change it own
                    let newDate = dateFormatter.string(from: date) //pass Date here
                    print(newDate)
                    
                    objMygrivance.strcreatedDate = newDate;
                    objMygrivance.strdescription = dict["description"] as! String;
                    objMygrivance.strCategoryEn = dict["CategoryEn"] as! String;
                    objMygrivance.strimageName = dict["imageName"] as! String;
                    objMygrivance.istatus = dict["status"] as! Int;
                    objMygrivance.iIssueNumber = dict["IssueNumber"] as! Int;
                    objMygrivance.iautoRatingLevel1 = dict["autoRatingLevel1"] as! Int;
                    objMygrivance.iautoRatingLevel2 = dict["autoRatingLevel2"] as! Int;
                    objMygrivance.icategoryID = dict["categoryID"] as! Int;
                    objMygrivance.iIssueID = dict["id"] as! Int;
                    self.arrGrivance.add(objMygrivance)
                    
                }
                self.tableView.reloadData();
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
        }
        
        
    }
    @IBAction func btnDetailPressed(_ sender: UIButton)
    {
        let objMygrivance:MyGrivance = arrGrivance[sender.tag] as! MyGrivance
        
       
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GrivanceDetailViewController") as! GrivanceDetailViewController
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        backItem.title = " "
        vc.delegate=self
        vc.issueId = objMygrivance.iIssueID
       // backItem.title = "Grievances Details"
        navigationController?.pushViewController(vc,animated: true)
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 300))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    
    func ChaneStatusReflect()
    {
        getGrivance()
    }
        
        
    

}
