//
//  ForgetPasswordViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 08/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var btnClosePressed: UIButton!
    @IBOutlet weak var txtEmailId: UnderlineTextfield!
    
    // MARK: - View lifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Button Click Method
    @IBAction func btnReserpasswordPressed(_ sender: AnyObject)
    {
        forgotPassword();
    }
    
    @IBAction func btnClosePressed(_ sender: AnyObject)
    {
         _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - forgot Password
    func forgotPassword()
    {
        
        let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        
        let  parameters = ["language": "ENG", "userType": 0,"email": txtEmailId.text!] as [String : Any]
        
        
        client?.invokeAPI("emailpasswordlink", body: nil, httpMethod: "POST", parameters: parameters, headers: nil)
        {
            (result, response, error) -> Void in
            if let err = error {
                print("ERROR ", err)
            }
            else if (result as! NSDictionary? as! [String:Any]?) != nil
            {
                
                    //print("Todo Item: ",dict["email"]!)
                 print("Todo Item: ",result!)
                
                // Do something with result
            }
        }
        
        
    }
    
    
    
    
    
    
    
   
}
