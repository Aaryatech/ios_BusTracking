//
//  SOSViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 03/07/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import ContactsUI
class SOSViewController: UIViewController,CNContactPickerDelegate,UITableViewDataSource,UITableViewDelegate {
var arrContactInfo = NSMutableArray()
    @IBOutlet  var tblContact: UITableView!
    @IBOutlet  var lblCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblContact.tableFooterView = UIView(frame: .zero)
        self.title = "Emergency Contact"
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
        let data = UserDefaults.standard.data(forKey: "UserContact");
        
        if (data != nil)
        {
            arrContactInfo = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSMutableArray)!
        }
        if arrContactInfo.count == 0
        {
           // lblNoFavrute.isHidden=false;
            tblContact.isHidden=true;
        }
        
       lblCount.text = "You can add upto \(5-arrContactInfo.count) Contacts" 
        
    }
    @IBAction func btnAddContact(_ sender: Any)
    {
     
        if(arrContactInfo.count == 5)
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"You have alredy added 5 contacts")
        }
        else
        {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
        }
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact])
    {
        
        
        
            contacts.forEach { contact in
                var strNumber:String = ""
                for number in contact.phoneNumbers {
                    
                    let phoneNumber = number.value
                    print("number is = \(phoneNumber.value(forKey: "digits"))")
                    print("number is = \(phoneNumber.value(forKey: "countryCode"))")
                    strNumber = (phoneNumber.value(forKey: "digits") as! String)
                    break;
                    
                }
                
                let objContact = clsContactNumber(strName:(contact.givenName + contact.familyName) as String , strContactNumber: strNumber as String);
                
                var isFound:Bool = false
                for contactinfo in arrContactInfo
                {
                let ContactNumber:String = (contactinfo as! clsContactNumber).strContactNumber as String
                let Contactname:String = (contactinfo as! clsContactNumber).strName as String
                    
                    if((Contactname == objContact.strName) && (ContactNumber==objContact.strContactNumber))
                    {
                        isFound=true;
                        break;
                    }
                }
                 if(isFound==false )
                 {
                    if(arrContactInfo.count < 5)
                    {
                        arrContactInfo.add(objContact)
                    }
                    else
                    {
                        let window :UIWindow = UIApplication.shared.keyWindow!
                        window.makeToast(message:"You can add maximum 5 contacts")
                        
                    }
            }
            else
             {
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"Contact already exists in your list")
                
             }
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrContactInfo)
            UserDefaults.standard.set(encodedData, forKey: "UserContact")
            tblContact.isHidden = false
            tblContact.reloadData();
             lblCount.text = "You can add upto \(5-arrContactInfo.count) Contacts"
        }
        
        
        
        
       
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController)
    {
        print("Cancel Contact Picker")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
        ;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return arrContactInfo.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact")as! ContactTableViewCell;
        let objContact:clsContactNumber = arrContactInfo[indexPath.row] as! clsContactNumber;
        
        cell.btnCancle.tag = indexPath.row;
        cell.lblName?.text=objContact.strName;
        cell.lblPhoneNumber?.text=objContact.strContactNumber ;
       
        
        
        return cell;
        
    }
    @IBAction func btnCanclePressed(_ sender: UIButton)
    {
        let objContactInfo1:clsContactNumber = arrContactInfo[sender.tag] as! clsContactNumber
        
        for objContactInfo in arrContactInfo
        {
            if ((objContactInfo as! clsContactNumber).strContactNumber == objContactInfo1 .strContactNumber)
            {
               
                arrContactInfo.remove(objContactInfo)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrContactInfo)
                UserDefaults.standard.set(encodedData, forKey: "UserContact")
                break;
            }
        }
        tblContact.reloadData();
        lblCount.text = "You can add upto \(5-arrContactInfo.count) Contacts"
    }

}
