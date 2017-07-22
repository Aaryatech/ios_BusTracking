//
//  GrivianceViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 12/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import SearchTextField
import AFNetworking
import NVActivityIndicatorView
import CoreLocation
import GoogleMaps
protocol RemoveRegisterGrivance
{
    func RemoveRegisterSubview()
    func PendingStatus(status:Int,objGrivance:MyGrivance )
    
    
}

class GrivianceViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,kDropDownListViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate {
    var   Dropobj=DropDownListView()
    @IBOutlet weak var clvCategory: UICollectionView!
    var viewController:AddSubViewController! = nil
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var txtBusNumber: SearchTextField!
    @IBOutlet weak var autocompleteContainerView: UIView!
    @IBOutlet weak var btnImageClose: UIButton!
    var allowAnonymous:Int=0
    var delegate:RemoveRegisterGrivance! = nil
    @IBOutlet weak var htCollectionView: NSLayoutConstraint!
    let locationManager = CLLocationManager();
    @IBOutlet weak var htViewImage: NSLayoutConstraint!
    var MuncipaltyID:Int=0
    var selectedRow:Int=9
    var SubCategoryID:Int=0
    var busNumbers = [String]();
    @IBOutlet weak var ViwHightBusNubmber: NSLayoutConstraint!
    @IBOutlet weak var htbtnPostGrievance: NSLayoutConstraint!
    
    @IBOutlet weak var htViewDescription: NSLayoutConstraint!
    
    @IBOutlet weak var viwGrivanceSubType: UIView!
    @IBOutlet weak var ViwHightType: NSLayoutConstraint!
    @IBOutlet weak var viwBusNumber: UIView!
    
    
    
    @IBOutlet weak var viwImage: UIView!
    
    @IBOutlet weak var viwDescription: UIView!
    
     @IBOutlet weak var viwPostGrievance: UIView!
      // var countryNames = [String]()
    @IBOutlet weak var lblBusNumber: UILabel!
    var arrCategory=NSMutableArray();
    var menuArray:Array=[GrivanceCategory]();
    var imagePicker : UIImagePickerController!
    @IBOutlet weak var imgGrivence: UIImageView!
    @IBOutlet weak var viwCamera: UIView!
    var autoCompleteViewController: AutoCompleteViewController!
    var uuid=String();
    var imainCategoryIdSelected:Int=0
    @IBOutlet weak var txtDescription: UITextView!
    var IsDropDownOpen:Bool = false
    var isFirstLoad: Bool = true
    var  sasURL1:String = ""
    var tap = UITapGestureRecognizer()
    var lat:CGFloat=0.0;
    var long:CGFloat=0.0;
    var strAddress:String = ""
    var strcity:String = ""
    var strzip:String = ""
    var strCountry:String = ""
    var strstate:String = ""
    //var  sasURL1:String = ""
    
    
    
    
    @IBAction func btnImageClosePressed(_ sender: Any)
    {
        viwCamera.isHidden = false;
        btnImageClose.isHidden=true;
        imgGrivence.isHidden=true;
    }
    @IBAction func btnCametaPressed(_ sender: AnyObject)
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnGallerypressed(_ sender: AnyObject)
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        self.present(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //GetCategory(Catid: 1)
        let objBusNumber = clsBusNumber();
        busNumbers = objBusNumber.addBusNumber()
        let mainCat1 = GrivanceCategory();
        mainCat1.strTitleEN="Bus Maintenance";
        mainCat1.strimageName="bus_maintenance";
        mainCat1.iMainCategoryID = 1
        
        let mainCat2 = GrivanceCategory();
        mainCat2.strTitleEN="Driver & Conductor";
        mainCat2.strimageName="driver_conductor";
        mainCat2.iMainCategoryID = 2
        
        let mainCat3 = GrivanceCategory();
        mainCat3.strTitleEN="Suggestions";
        mainCat3.strimageName="suggestions";
        mainCat3.iMainCategoryID = 3
        
        let mainCat4 = GrivanceCategory();
        mainCat4.strTitleEN="Lost & Found";
        mainCat4.strimageName="lost_found";
        mainCat4.iMainCategoryID = 4
        
        let mainCat5 = GrivanceCategory();
        mainCat5.strTitleEN="BRT";
        mainCat5.strimageName="BRT";
        mainCat5.iMainCategoryID = 5
        
        let mainCat6 = GrivanceCategory();
        mainCat6.strTitleEN="Bus Stop";
        mainCat6.strimageName="bus_stop";
        mainCat6.iMainCategoryID = 6
        
        let mainCat7 = GrivanceCategory();
        mainCat7.strTitleEN="Pass";
        mainCat7.strimageName="pass";
        mainCat7.iMainCategoryID = 7
        
        // login();
        menuArray=[mainCat1,mainCat2,mainCat3,mainCat4,mainCat5,mainCat6,mainCat7];
        
        htCollectionView.constant=(((self.view.frame.size.width-40)/3)*3)+20;
        txtBusNumber.startVisible = true
        txtBusNumber.filterStrings(busNumbers)
        
        
        
        txtDescription.text = "Grievance Description"
        txtDescription.textColor = UIColor.lightGray
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        //self.view.addGestureRecognizer(tap)
        tap.isEnabled = false
        // Do any additional setup after loading the view.
        
        htbtnPostGrievance.constant=0;
        htViewDescription.constant=0;
        ViwHightBusNubmber.constant=0;
        ViwHightType.constant=0;
        htViewImage.constant=0;
        viwGrivanceSubType.isHidden=true;
        viwBusNumber.isHidden=true;
        viwDescription.isHidden=true;
        viwImage.isHidden=true;
        viwPostGrievance.isHidden=true;
        
        
        
        btnCategory.layer.cornerRadius = 5
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.borderColor = UIColor.clear.cgColor
        
        txtBusNumber.layer.cornerRadius = 5
        txtBusNumber.layer.borderWidth = 1
        txtBusNumber.layer.borderColor = UIColor.clear.cgColor
        
        txtDescription.layer.cornerRadius = 5
        txtDescription.layer.borderWidth = 1
        txtDescription.layer.borderColor = UIColor.clear.cgColor
        //viwImage.border
        let borderLayer  = dashedBorderLayerWithColor(color: UIColor.lightGray.cgColor)
         let objsetting = clsSetting();
        imgGrivence.layer.addSublayer(borderLayer)
        if objsetting.isInternetAvailable()
        {
            
        
        if (UserDefaults.standard.integer(forKey: "id")>0 )
        {
            PendingGrivance();
            determineMyCurrentLocation()
        }
        }
        else
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
        }
       
        
    }
    
    
    func dashedBorderLayerWithColor(color:CGColor) -> CAShapeLayer {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = imgGrivence.frame.size
        let shapeRect = CGRect(x:0,y:0,width:(self.view.frame.size.width - 56),height:frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x:((self.view.frame.size.width - 56)/2),y:frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth=0.5
        borderLayer.lineJoin=kCALineJoinRound
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 8),NSNumber(value:4)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        
        return borderLayer
        
    }
    
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        IsDropDownOpen = false
        
        tap.isEnabled = false
            Dropobj.fadeOut()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            //Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Grievance Description"
            textView.textColor = UIColor.lightGray
        }
    }
    

    
    func GetCategory(Catid:Int)
    {
        
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        //let table = client?.table(withName: "user")
       // (20.013413, 73.741962)
        let  parameters = ["latitude": "18.505962", "longitude": "73.795071","city":"pune","country":"India","mainCategoryId":Catid] as [String : Any]
        
        
        client?.invokeAPI("municipality/getMunicipality", body: nil, httpMethod: "GET", parameters: parameters, headers: nil)
        {
            (result, response, error) -> Void in
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"Pleae check internet connection")
            }
            else if let dict = result as! NSDictionary? as! [String:Any]?
            {
                
                self.arrCategory.removeAllObjects()
               //print("Todo Item: ",dict["municipalityId"]!)
                print("Todo Item: ",result)
                //self.allowAnonymous = dict["allowAnonymous"] as Any as! Int;
                self.MuncipaltyID = dict["id"] as! Int;
                self.arrCategory=dict["categories"] as! NSMutableArray
                ;
               /* for objCat in arrCat
                {
                    let objCategory = GrivanceCategory()
                   let itemDict = objCat as? [String:AnyObject]
                   // var dict:Dictionary = (objCat as AnyObject).resultDictionary()
                   //let dict = objCat as NSDictionary? as! [String:Any]?
                    objCategory.strTitle = itemDict?["titleEN"] as! String
                    objCategory.iMainCategoryID = itemDict?["mainCategoryID"] as! Int;
                    objCategory.strTitle = itemDict?["descriptionTextEN"] as! String
                    
                    self.arrCategory.add(objCategory);
                   
                }*/
                // Do something with result
                self.clvCategory.reloadData();
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }
        
        
        
        
    }
    func PendingGrivance()
    {
        
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let userID:String = UserDefaults.standard.string(forKey: "id")!
        let  parameters = ["citizenID": userID, "municipalityID": "1"] as [String : Any]
        
        
        appDelegate.client.invokeAPI("municipality/getIssuesForFeedbackRating", body: nil, httpMethod: "GET", parameters: parameters, headers: nil)
        {
            (result, response, error) -> Void in
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"Pleae check internet connection")
            }
            else if let arr:NSArray = result as? NSArray
            {
                
                print("Pending Grivance Todo Item: ",arr)
                if(arr.count>0)
                {
                    let dict = arr[0] as! NSDictionary
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
                    
                    
                    let alert = UIAlertController(title: "PMPML", message: "You have \(arr.count) grievances in resolved state. please provide feedback to register new grievance", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "NOT NOW", style: UIAlertActionStyle.default, handler: { action in
                        self.view.removeFromSuperview()
                        self.delegate!.PendingStatus(status: 0, objGrivance: objMygrivance)
                        
                        
                        }))
                    alert.addAction(UIAlertAction(title: "PPROCEED", style: UIAlertActionStyle.default, handler: { action in
                        self.view.removeFromSuperview()
                         self.delegate!.PendingStatus(status: 1, objGrivance: objMygrivance)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
               /* for item in arr
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
                    
                }*/
 
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }
        
        
        
        
    }
    
    
    

    // MARK: - UIColletion DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            return menuArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath)as! HomeMenuCollectionViewCell;
            let objGrivanceCategory:GrivanceCategory=menuArray[ indexPath.row];
            cell.lnlMenuItem.text=objGrivanceCategory.strTitleEN;
            cell.imgMenu.image = UIImage(named: objGrivanceCategory.strimageName);
            
            if indexPath.row == selectedRow
            {
                cell.lnlMenuItem.alpha = 1
                cell.imgMenu.alpha = 1
                
            }
            else
            {
                cell.lnlMenuItem.alpha = 0.4
                cell.imgMenu.alpha = 0.4
                
            }
             if selectedRow==9
             {
                    cell.lnlMenuItem.alpha = 1
                    cell.imgMenu.alpha = 1
              }
            return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        let objCategory:GrivanceCategory = menuArray[indexPath.row];
        
        if (objCategory.iMainCategoryID == 1)||(objCategory.iMainCategoryID == 2) || (objCategory.iMainCategoryID == 6)
        {
            ViwHightBusNubmber.constant=77
            viwBusNumber.isHidden=false
            ViwHightType.constant=77
            viwGrivanceSubType.isHidden=false
            
            if objCategory.iMainCategoryID == 6
            {
                lblBusNumber.text = "Bus Stop"
                txtBusNumber.placeholder = "Add Bus Stop"
                GetAllBusStop();
            }
            else
            {
            lblBusNumber.text = "Bus Number"
            txtBusNumber.placeholder = "Add Bus Number"
                let objBusNumber = clsBusNumber();
                busNumbers = objBusNumber.addBusNumber()
            }
            
            
        }
       else if (objCategory.iMainCategoryID == 3)||(objCategory.iMainCategoryID == 5||(objCategory.iMainCategoryID == 7))
        {
            ViwHightBusNubmber.constant=0
            viwBusNumber.isHidden=true
            ViwHightType.constant=77
            viwGrivanceSubType.isHidden=false
        }
        else if (objCategory.iMainCategoryID == 4)
        {
            ViwHightBusNubmber.constant=0
            viwBusNumber.isHidden=true
            ViwHightType.constant=0
            viwGrivanceSubType.isHidden=true
        }
        
        viwDescription.isHidden = false;
        htViewDescription.constant=150;
        viwImage.isHidden = false;
        htViewImage.constant=157
        viwPostGrievance.isHidden=false;
        htbtnPostGrievance.constant=60
        
        GetCategory(Catid: objCategory.iMainCategoryID);
        selectedRow=indexPath.row
        imainCategoryIdSelected = objCategory.iMainCategoryID
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        // let paddingSpace = sectionInsets.left * (3 + 1)
        //let availableWidth = view.frame.width - paddingSpace
        
        let widthPerItem = (self.view.frame.size.width-40) / 3
       
        return CGSize(width: widthPerItem, height:widthPerItem)
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsetsMake(topMargin, left, bottom, right);
    }
    @IBAction func btnGrivanceSubtypePressed(_ sender: AnyObject)
    {
        if self.arrCategory.count>0
        {
            
           
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            viewController = storyboard.instantiateViewController(withIdentifier: "AddSubViewController") as! AddSubViewController
            
            self.addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
            viewController.view.frame = view.bounds
            self.view!.addSubview(viewController.view!)
            
            

            Dropobj = DropDownListView(title: "Select grievance sub - type", options: self.arrCategory as [AnyObject], xy: CGPoint(x:25, y:150), size: CGSize(width: (self.view.frame.size.width-50), height: (self.view.frame.size.height-200)), isMultiple: false, parseKey: "titleEN")
            Dropobj.show(in: viewController.view, animated: true)
            // 0.0 G:108.0 B:194.0 alpha:0.70
            Dropobj.delegate=self;
            Dropobj.setBackGroundDropDown1_R(39, g: 57.0, b: 128.0, alpha: 0.70)
            
        }
       
    }
    
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int)
    {
        let dict = arrCategory[anIndex] as! [String : Any];
        btnCategory.setTitle(dict["titleEN"] as! String?,for: .normal)
        SubCategoryID = dict["id"] as! Int ;
        
        
        viewController.view.removeFromSuperview();
        
    }
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        
    }
    func dropDownListViewDidCancel() {
        
        
    }
    
    
    
    @IBAction func btngrivanceRegisterpressed(sender: AnyObject)
    {
        txtBusNumber.resignFirstResponder()
        txtDescription.resignFirstResponder()
        if Validation()==true
        {
            
            
            if (UserDefaults.standard.integer(forKey: "id")==0)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.isCommingFromGrivance = 1
                navigationController?.pushViewController(vc,animated: true)
            }
            else
            {
            
                let objsetting = clsSetting();
                if(!objsetting.isInternetAvailable())
                {
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.makeToast(message:"Internet Connection Unavailable.Please connect to internet by turning your Data or Wi-Fi.")
                }
                else
                {
                    RegisterGrivance();
                }
            }
        }
        
    }
    func RegisterGrivance()
    {
        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       // let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        let table = appDelegate.client.table(withName: "issue")
        
       // let newItem = ["title": "grievance" ,"categoryID": SubCategoryID , "latitude": 18.505962, "longitude": 73.795071,"address": "Kothrud Depot","imageName":"417DDFA6-8BA8-481A-964B-E8A7CCB36F29","description":"abc","pincode":"422004","city":"PUNE","state":"Maharashtra","country":"india","BusStop":"","busNumber":"1180"] as [String : Any]
        
      let  uuid = UUID().uuidString
        print(uuid)
         //let newItem = ["title": "grievance" ,"categoryID": SubCategoryID , "latitude": 18.505962, "longitude": 73.795071,"address": "Swargate","imageName":uuid,"description":txtDescription.text,"pincode":"411006","city":"PUNE","state":"Maharashtra","country":"India","busStop":"","busNumber":txtBusNumber.text!] as [String : Any]
        
        let newItem = ["title": "grievance" ,"categoryID": SubCategoryID , "latitude": lat, "longitude": long,"address": strAddress,"imageName":uuid,"description":txtDescription.text,"pincode":strzip,"city":strcity,"state":strstate,"country":strCountry,"busStop":txtBusNumber.text!,"busNumber":txtBusNumber.text!] as [String : Any]
        print(newItem)
        table?.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                 NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.view.makeToast(message: "Grievance not posted Successfully,Please try again!", duration: 3, position: HRToastPositionDefault as AnyObject)
            }
            else if  let dict = result as NSDictionary? as! [String:Any]?
            {
                print("Todo Item: ",dict)
                
                
                if(self.imgGrivence.image == nil)
                {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.view.makeToast(message: "Grievance posted Successfully!", duration: 3, position: HRToastPositionDefault as AnyObject)
                    self.view.removeFromSuperview()
                    self.delegate!.RemoveRegisterSubview()
                    
                    
                }
                else
                {
                        self.SasURL(UUID: uuid,IssueID1:dict["id"] as! Int);
                }
               
            }
        }
        
        
    }

    func SasURL(UUID:String,IssueID1:Int)
    {
        
        //let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        //let table = client?.table(withName: "user")
        
        let  parameters = ["blobName": UUID, "containerType": "issue"] as [String : Any]
        
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
       appDelegate.client.invokeAPI("sasurlgenerator", body: nil, httpMethod: "GET", parameters: parameters, headers: nil)
        {
            (result, response, error) -> Void in
            if let err = error {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.view.makeToast(message: "Grievance not posted Successfully,Please try again!", duration: 3, position: HRToastPositionDefault as AnyObject)
                print("ERROR ", err)
            }
            else if let dict = result as! NSDictionary? as! [String:Any]?
            {
                
                //print("Todo Item: ",dict["email"]!)
                self.sasURL1=dict["sasUrl"] as! String
                print("Todo Item: ",result!)
                self.getIssueimage(issueID:IssueID1, url: self.sasURL1)
                self.imageUploadRequest1(imageView: self.imgGrivence, uploadUrl: NSURL(string: self.sasURL1)!, param: nil)
                
                
                
                // Do something with result
            }
        }
        
        
        
        
    }

    
    
    func getIssueimage(issueID:Int ,url:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        let table = appDelegate.client.table(withName: "image")
        
       // let newItem = ["issueID": issueID , "url": "email","imageType": ""] as [String : Any]
        
        let newItem = ["issueID": issueID , "url": url,"imageType": ""] as [String : Any]
        
        let userID:String = UserDefaults.standard.string(forKey: "id")!
        let parameter = ["userID": userID] as [String : Any]
        
        table?.insert(newItem, parameters: parameter) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                //self.view.makeToast(message: "User not register successfully,Please try again!", duration: 3, position: HRToastPositionDefault as AnyObject)
            }
            else if let dict = result as NSDictionary? as! [String:Any]?
            {
               
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.makeToast(message:"Grievance Posted Successfully")
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                /*let BusStopvc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
                let navigationController:UINavigationController = UINavigationController(rootViewController: BusStopvc)
                
                //self.revealViewController().rightRevealToggle(animated: true)
                self.revealViewController() .setFront(navigationController, animated: true)
                */
                self.view.removeFromSuperview()
                self.delegate!.RemoveRegisterSubview()
                
            }
        }
        
        
    }
    
    
    
    
    func getIssueDetail(issueId : Int?)  {
        let client  = MSClient(applicationURLString: "https://fixipmpmldev.azure-mobile.net/",applicationKey: "SPHaNdUtNOhKYgkdFtBAFEdtcEWjcG79")
        let table = client?.table(withName: "issue")
        let query = table?.query()
        query?.parameters = ["id": issueId!]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        query?.read(){
            (result ,error) in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //var issue: Issue?
            
            if let err = error {
                print("ERROR ", err)
            }
            else if (result as! NSDictionary? as! [String:Any]?) != nil
            {
                
                //self.arrCategory.removeAllObjects()
                //print("Todo Item: ",dict["municipalityId"]!)
                print("Todo Item: ",result)
                //self.allowAnonymous = dict["allowAnonymous"] as Any as! Int;
                // self.MuncipaltyID = dict["id"] as! Int;
                //self.arrCategory=dict["categories"] as! NSMutableArray
                ;
                /* for objCat in arrCat
                 {
                 let objCategory = GrivanceCategory()
                 let itemDict = objCat as? [String:AnyObject]
                 // var dict:Dictionary = (objCat as AnyObject).resultDictionary()
                 //let dict = objCat as NSDictionary? as! [String:Any]?
                 objCategory.strTitle = itemDict?["titleEN"] as! String
                 objCategory.iMainCategoryID = itemDict?["mainCategoryID"] as! Int;
                 objCategory.strTitle = itemDict?["descriptionTextEN"] as! String
                 
                 self.arrCategory.add(objCategory);
                 
                 }*/
                // Do something with result
                //self.clvCategory.reloadData();
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        picker.dismiss(animated: true, completion: { () -> Void in
            
           /* var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            
            imageCropVC.delegate = self
            
            //self.navigationController?.pushViewController(imageCropVC, animated: true)
            self.present(imageCropVC, animated: true, completion: nil)*/
            
            self.imgGrivence.image=image
            self.viwCamera.isHidden = true
            self.imgGrivence.isHidden = false
            self.btnImageClose.isHidden = false
           // dismiss(animated: true, completion: nil)
            
            
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
       imgGrivence.image=croppedImage
        viwCamera.isHidden = true
        imgGrivence.isHidden = false
        btnImageClose.isHidden = false
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imageUploadRequest(imageView: UIImageView, uploadUrl: NSURL, param: [String:String]?) {
        
        //let myUrl = NSURL(string: "http://192.168.1.103/upload.photo/index.php");
        
        let request = NSMutableURLRequest(url:uploadUrl as URL);
        request.httpMethod = "PUT"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        //myActivityIndicator.startAnimating();
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest,
                                                                 completionHandler: {
                                                                    (data, response, error) -> Void in
                                                                    if let data = data {
                                                                        
                                                                        // You can print out response object
                                                                        print("******* response = \(response)")
                                                                        
                                                                        print(data.count)
                                                                        // you can use data here
                                                                        
                                                                        // Print out reponse body
                                                                        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                                        print("****** response data = \(responseString!)")
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    }
        })
        task.resume()
        
        
    }
    
     func imageUploadRequest1(imageView: UIImageView, uploadUrl: NSURL, param: [String:String]?)
     {
        if let imageData:NSData = UIImageJPEGRepresentation(imageView.image!, 0.1) as NSData? {
            let encodedImageData = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            var request = URLRequest(url: uploadUrl as URL)
            request.httpMethod = "PUT"
            request.setValue("image/jpeg",forHTTPHeaderField: "Content-Type")
            //let postString = "image=\(encodedImageData)"
            //request.httpBody = postString.data(using: .utf8)
           // URLSession.shared.uploadTask(with: request, from: encodedImageData)
            let task = URLSession.shared.uploadTask(with: request, from: imageData as Data) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(error)")
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.view.makeToast(message: "Grievance not posted Successfully,Please try again!", duration: 3, position: HRToastPositionDefault as AnyObject)
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    //self.getIssueimage(issueID:IssueID1, url: self.sasURL1)
                    //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    
                    
                   
                    
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
            }
            task.resume()
        }
            
            
            
            
            
        }
    
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    func Validation() -> Bool
    {
        let window :UIWindow = UIApplication.shared.keyWindow!
        if((btnCategory.titleLabel?.text == "Select Grievance Sub Type")&&(((imainCategoryIdSelected==1)||(imainCategoryIdSelected==2)||(imainCategoryIdSelected==3)||(imainCategoryIdSelected==5))))
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please select grievance sub category")
        return false
            
        }
        else if((txtBusNumber.text=="") && ((imainCategoryIdSelected==1)||(imainCategoryIdSelected==2)||(imainCategoryIdSelected==6)))
        {
            
            if(imainCategoryIdSelected==6)
            {
            window.makeToast(message:"Please Enter Bus Stop")
            }
            else
            {
            window.makeToast(message:"Please Enter Bus Number")
            }
        return false
        }
        else if(txtDescription.text == "Grievance Description")
        {
            window.makeToast(message:"Please enter Grievance Description")
            return false;
        }
        
        return true
    }
    
    
    func GetAllBusStop()
    {
        
        let fileManager = FileManager()
        let filepath=fileManager.urls(for:.documentDirectory,in:.userDomainMask)
        let databsePathStr:String=filepath[0].appendingPathComponent("gtfs.db").path as String;
        if fileManager.fileExists(atPath: databsePathStr as String)
        {
            let mydatabase = FMDatabase(path:databsePathStr as String)
            if mydatabase == nil
            {
                print("Database:\(mydatabase?.lastErrorMessage())")
            }
            if (mydatabase?.open())!
            {
                let getBusStop = "select DISTINCT stop_name from stops"
                print(getBusStop)
                let resultSet:FMResultSet = (mydatabase?.executeQuery(getBusStop, withArgumentsIn: nil))!
                let index:Int = 65;
                
                let arrTemp = NSMutableArray()
                while (resultSet.next()==true)
                {
                    var dict:Dictionary = resultSet.resultDictionary()
                    
                    //let objBusStopInfo = clsBusStopInfo(strlocation_type: dict["location_type"] as! String, strparent_station: dict["parent_station"] as! String,istop_code: dict["stop_code"] as! Int,strstop_desc: dict["stop_desc"] as! String,strstop_name: dict["stop_name"] as! String,strstop_timezone: dict["stop_timezone"] as! String,strstop_url: dict["stop_url"] as! String,strwheelchair_boarding: "",strzone_id: "",dstop_lat: dict["stop_lat"] as! Double,dstop_lon: dict["stop_lon"] as! Double,strIndex: String(UnicodeScalar(index)!),istop_id: dict["stop_id"] as! Int,istop_sequence:0,izone_id:dict["zone_id"] as! String,strarrival_time: "");
                    arrTemp.add(dict["stop_name"] as! String)
                    //arrAllBusStop.add(objBusStopInfo)
                    //index=index+1
                    //print(objBusStopInfo)
                }
                
                
                
                busNumbers = arrTemp.flatMap({ $0 as? String })
                
                mydatabase?.close();
            }
        }
        
    }

    func getAddressFromLat(lat:CGFloat, long:CGFloat)
    {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
            }
            
            // Access each element manually
            if let locationName = addressDict["Name"] as? String
            {
                self.strAddress = locationName;
                print(locationName)
            }
            if let street = addressDict["Thoroughfare"] as? String {
                self.strAddress = self.strAddress + street
                print(street)
            }
            if let city = addressDict["City"] as? String {
                print(city)
                self.strcity = city
            }
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
                self.strzip = zip
            }
            if let country = addressDict["Country"] as? String {
                print(country)
                self.strCountry = country
            }
            if let state = addressDict["State"] as? String {
                print(state)
                self.strstate = state
            }
        })
        
        
    }

    
    func determineMyCurrentLocation() {
        /* if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
         */
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    
        //}
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        lat=CGFloat(userLocation.coordinate.latitude);
        long=CGFloat(userLocation.coordinate.longitude);
        
       getAddressFromLat(lat: CGFloat(userLocation.coordinate.latitude), long: CGFloat(userLocation.coordinate.longitude))
        
               locationManager.stopUpdatingLocation()
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    

}

extension GrivianceViewController: AutocompleteDelegate {
    public func top() -> CGFloat {
      return  100;
    }

    func autoCompleteTextField() -> UITextField {
        return self.txtBusNumber
    }
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }
    func ContainerView() -> UIView {
        return self.autocompleteContainerView
    }
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        let filteredCountries = self.busNumbers.filter { (country) -> Bool in
            return country.lowercased().contains(term.lowercased())
        }
        
        let countriesAndFlags: [AutocompletableOption] = filteredCountries.map { ( country) -> AutocompleteCellData in
            var country = country
            country.replaceSubrange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalized)
            return AutocompleteCellData(text: country, image: UIImage(named: country))
            }.map( { $0 as AutocompletableOption })
        
        return countriesAndFlags
    }
    
    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    
    func didSelectItem(_ item: AutocompletableOption,indexpathrow:Int) {
        txtBusNumber.text = item.text
    }
    
    /*func sendImageToServer(url:String) {
     
        let request =  NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
     
        //        uploadTask = session.uploadTaskWithRequest(request, fromFile: NSURL(fileURLWithPath: imageFilePath!)!, completionHandler: {data, response, error -> Void in
        //
        //            if ((error) != nil) {
        //                self.completionHandler(false, error)
        //            }
        //            else
        //            {
        //                self.completionHandler(true, nil)
        //            }
        //        })
     
        print("Image \(self.imgGrivence)", terminator: "")
     
        let imageData : NSData = UIImageJPEGRepresentation(self.imgGrivence.image!, 0.1)! as NSData
        session.uploadTaskWithRequest(request, fromData: imageData, completionHandler: { (data, response, error) -> Void in
            if ((error) != nil) {
                print("Error --- \(error)")
     
                self.completionHandler(false, error)
            }
            else
            {
                self.completionHandler(true, nil)
            }
        })
     
     
    }*/
   
    
// extension for impage uploading


    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

