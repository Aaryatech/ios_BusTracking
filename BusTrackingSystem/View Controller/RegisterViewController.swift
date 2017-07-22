//
//  RegisterViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 08/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtAddress: UnderlineTextfield!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtName: UITextField!
     var Show:Int = 0;
    @IBOutlet weak var txtEmail: UITextField!
    var imagePicker : UIImagePickerController!
    @IBOutlet weak var btnUserPhotos: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    
     // MARK: - Button Clicked Custome Method
    @IBAction func btnUserPhoto(_ sender: Any)
    {
        
        
        let alert = UIAlertController(title: "Upload Pictures Option", message: "How do you want to set your picture?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { action in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            self.present(self.imagePicker, animated: true, completion: nil)
           
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { action in
            
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
        
        
        
    }
    @IBAction func btnregisterPressed(_ sender: Any)
    {
        if (UserDefaults.standard.integer(forKey: "id")>0)
        {
            if ValidationUpdateProfile()==true
            {
             UpdateProfile();
            }
            
           
        }
        else
        {
            if Validation() == true
            {
             Registration();
            }
            
        }
        
    }
    @IBAction func btnShowPressed(_ sender: Any)
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
    
    @IBAction func btnClosePressed(_ sender: AnyObject)
    {
        if (UserDefaults.standard.integer(forKey: "id")>0)
        {
            let BusStopvc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
            let navigationController:UINavigationController = UINavigationController(rootViewController: BusStopvc)
            
            //self.revealViewController().rightRevealToggle(animated: true)
            self.revealViewController() .setFront(navigationController, animated: true)
        }
        else
        {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
     // MARK: - View Life Cycle Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    func viewWilldisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (UserDefaults.standard.integer(forKey: "id")>0)
        {
            txtPassword.isSecureTextEntry = false
            txtName.text = UserDefaults.standard.string(forKey: "name")
            txtEmail.text = UserDefaults.standard.string(forKey: "userEmail")
            txtPassword.text = UserDefaults.standard.string(forKey: "mobileNumber")
            lblPassword.text="Mobile Number"
            btnShow.isHidden = true;
            lblAddress.isHidden = false;
            txtAddress.isHidden = false;
            btnUserPhotos.isHidden = false;
            txtAddress.text = UserDefaults.standard.string(forKey: "address")
            self.title = "Edit Profile"
            btnSignup.setTitle("Update",for: .normal)
            lblTitle.text="Edit Profile"
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Validation Method
    func Validation() -> Bool
    {
        if (txtName.text == "")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter Name")
            return false;
        }
       else if (txtEmail.text == "")
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
    
    func ValidationUpdateProfile() -> Bool
    {
        if (txtName.text == "")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter name")
            return false;
        }
        else if (txtEmail.text == "")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter email")
            return false;
            
        }
        else if (txtPassword.text=="")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter mobile number")
            return false;
        }
        else if (txtAddress.text=="")
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please enter address")
            return false;
        }
        else
        {
            return true
        }
        
    }
    
    // MARK: - Uiimage Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        picker.dismiss(animated: true, completion: { () -> Void in
            
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            
            imageCropVC.delegate = self
            
            //self.navigationController?.pushViewController(imageCropVC, animated: true)
            self.present(imageCropVC, animated: true, completion: nil)
            
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect)
    {
         btnUserPhotos.setImage((croppedImage), for: UIControlState.normal)
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    // MARK: - Web Service method
    func Registration()
    {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let table = appDelegate.client.table(withName: "user")
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let newItem = ["password": txtPassword.text! ,"name": txtName.text! , "loginType": "email","email": txtEmail.text!,"accountID":"","gsmRegistrationID":"740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"] as [String : Any]
        
        
        table?.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.view.makeToast(message: "User not register successfully,Please try again!", duration: 3, position: HRToastPositionDefault as AnyObject)
            }
            else if  let dict = result as NSDictionary? as! [String:Any]?
            {
                print(dict)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"User Registered  Successfully Please Login")
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }

    
    func UpdateProfile()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let table = appDelegate.client.table(withName: "user")
        let strID:String = String( UserDefaults.standard.integer(forKey: "id"))
        
        let Address = ["line": txtAddress.text! ,"zip": "" , "city": "","country":""] as [String : Any]
        let newItem = ["id": strID ,"name": txtName.text! , "mobileNumber": txtPassword.text!,"address": Address,"imageURL":""] as [String : Any]
         print("Todo Item11: ",newItem)
        
        table?.update(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                self.view.makeToast(message: "User not register successfully,Please try again!", duration: 3, position: HRToastPositionDefault as AnyObject)
            }
            else if  let dict = result as NSDictionary? as! [String:Any]?
            {
                
                print(result!)
                UserDefaults.standard.set(dict["name"]!, forKey: "name")
                UserDefaults.standard.set(dict["mobileNumber"]!, forKey: "mobileNumber")
                
                let dictAddress = dict["address"] as! NSDictionary? as! [String:Any]?
                UserDefaults.standard.set(dictAddress?["line"]!, forKey: "address")
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"Updated Profile Successfully")
                let BusStopvc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
                let navigationController:UINavigationController = UINavigationController(rootViewController: BusStopvc)
                self.revealViewController() .setFront(navigationController, animated: true)
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
