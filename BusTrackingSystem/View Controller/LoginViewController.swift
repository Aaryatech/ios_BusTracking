//
//  LoginViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 08/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class LoginViewController: UIViewController {
 @IBOutlet weak var txtEmail: UITextField!
 @IBOutlet weak var txtPassword: UITextField!
    var isCommingFromGrivance:Int = 0
    var Show:Int = 0;
    
    @IBOutlet weak var btnRegister: UIButton!
    
     // MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        btnRegister.layer.borderWidth = 1
        btnRegister.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    func viewWilldisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - Custome ButtonClick Method
    @IBAction func btnClosePressed(_ sender: Any)
    {
        if isCommingFromGrivance == 1
        {
          _ = navigationController?.popViewController(animated: true)
        }
        else
        {
        let BusStopvc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
        let navigationController:UINavigationController = UINavigationController(rootViewController: BusStopvc)
        
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
            
            
        //self.revealViewController().rightRevealToggle(animated: true)
        self.revealViewController() .setFront(navigationController, animated: true)
        }
    }
    
    @IBAction func btnDhowPressed(_ sender: Any)
    {
        if Show==1
        {
            Show=0
            txtPassword.isSecureTextEntry = true
        }
        else
        {
        txtPassword.isSecureTextEntry = false
        Show=1
        }
    }
    @IBAction func btnForgetPassword(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        navigationController?.pushViewController(vc,animated: true)
    }

    @IBAction func btnLoginPressed(_ sender: Any)
    {
        if (Validation() == true)
        {
        txtEmail.resignFirstResponder();
        txtPassword.resignFirstResponder();
        loginCheck()
        }
    }
    
    @IBAction func btnRegisterPressed(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(vc,animated: true)
    }
     // MARK: - Btn Login Method (Web services)
    func Validation() -> Bool
    {
        if (txtEmail.text == "")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter Email")
            return false;
            
        }
        else if (txtPassword.text=="")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter password")
            return false;
        }
        else
        {
            return true
        }
        
    }
    func loginCheck()
    {
        
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        let table = appDelegate.client.table(withName: "user")
        
        let newItem = ["password": txtPassword.text! , "loginType": "email","email": txtEmail.text!] as [String : Any]
        let parameter = ["login": "true"] as [String : Any]
        
        table?.insert(newItem, parameters: parameter) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                 self.view.makeToast(message: "Invalid Credentials", duration: 3, position: HRToastPositionDefault as AnyObject)
                
            }
            else if let dict = result as NSDictionary? as! [String:Any]?
            {
                
                
                
                 print("Todo Item: ",dict["email"]!)
                 print("Todo Item: ",dict["id"]!)
                 print("Todo Item: ",dict["userID"]!)
                 print("Todo Item: ",dict["token"]!)
                 print("Todo Item: ",dict["neighbourhoodID"]!)
                 print("Todo Item: ",dict["name"]!)
                 print("Todo Item: ",dict["address"]!)
 
                
                
                UserDefaults.standard.set(dict["email"]!, forKey: "userEmail")
                UserDefaults.standard.set(dict["userID"]!, forKey: "userID")
                UserDefaults.standard.set(dict["id"]!, forKey: "id")
                UserDefaults.standard.set(dict["name"]!, forKey: "name")
                UserDefaults.standard.set(dict["token"]!, forKey: "token")
                
                let userID:String = UserDefaults.standard.string(forKey: "id")!
               let userID1 = userID.replacingOccurrences(of: "", with: "Custom:");
                let user = MSUser(userId: userID);
                user?.mobileServiceAuthenticationToken = UserDefaults.standard.string(forKey: "token")!
                appDelegate.client.currentUser = user
               
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                let window :UIWindow = UIApplication.shared.keyWindow!
                 window.makeToast(message:"User login Successfully")
                
                if (self.isCommingFromGrivance==1)
                {
                   self.navigationController?.popViewController(animated: true)
                    
                }
                else
                {
                    
                    let BusStopvc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
                    let navigationController:UINavigationController = UINavigationController(rootViewController: BusStopvc)
                    
                    let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                    navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                    navigationController.navigationBar.barStyle = .default
                    
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                    
                    
                    
                    //self.revealViewController().rightRevealToggle(animated: true)
                    self.revealViewController() .setFront(navigationController, animated: true)
                    
                    
                }
            }
        }
        
        
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
    
    
   

}
