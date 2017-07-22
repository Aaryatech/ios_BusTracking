//
//  MenuViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 01/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
@IBOutlet  var tblMenu: UITableView!
   
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var viwLogOut: UIView!
    var menuArray:Array=[HomeMenu]();
    
    @IBOutlet weak var htViwLogOut: NSLayoutConstraint!
    
     // MARK: - View lifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Home1 = HomeMenu();
        Home1.strMenu="Bus Tracker";
        Home1.strImageName="bus_stop_ico.png";
        
        let Home2 = HomeMenu();
        Home2.strMenu="Planner";
        Home2.strImageName="direction_ico.png";
        
        let Home3 = HomeMenu();
        Home3.strMenu="Favorite";
        Home3.strImageName="favorite_ico.png";
        
        let Home4 = HomeMenu();
        Home4.strMenu="Post Your Grievances";
        Home4.strImageName="grievances_ico.png";
        
        let Home5 = HomeMenu();
        Home5.strMenu="Emergency Contact";
        Home5.strImageName="grievances_ico.png";
        
        
        menuArray=[Home1,Home2,Home3,Home4,Home5];
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
               //tblMenu.reloadData()
        
        if (UserDefaults.standard.integer(forKey: "id")>1)
        {
            lblLoginTitle?.text="Welcome"
            lblUserName?.text=(UserDefaults.standard.string(forKey: "userEmail"))
            viwLogOut.isHidden = false;
            htViwLogOut.constant = 66;
        }
        else
        {
            lblLoginTitle?.text="Login / SIGNUP"
            lblUserName?.text="for personalize access"
            viwLogOut.isHidden = true;
            htViwLogOut.constant = 0;
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - UItableview Delegate Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section==0)
        {
            return 93;
        }
        else if (indexPath.section==1)
        {
            return 66;
        }
        else if (indexPath.section==2)
        {
            return 55;
        }
        
        else if (indexPath.section==3)
        {
            return 43;
        }
        else
        {
        return 45;
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if (UserDefaults.standard.integer(forKey: "id")>1)
        {

        return 5;
        }
        else
        {
        return 4;
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (UserDefaults.standard.integer(forKey: "id")>1)
        {
        if (section==0 || section==1 || section == 2 || section == 3)
        {
            return 1;
        }
        else
        {
            return menuArray.count;
        }
        }
        else
        {
            if (section==0 || section==1 || section == 2)
            {
                return 1;
            }
            else
            {
                return menuArray.count;
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (UserDefaults.standard.integer(forKey: "id")>1)
        {
        if (indexPath.section==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "First");
            
            
            return cell!;
            
        }
      else  if (indexPath.section==1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Second")as! MenuTableViewCell;
            let objHomeMenu:HomeMenu = menuArray[indexPath.row];
            cell.lblTitle?.text="Welcome"
            cell.lblSubTitle?.text=(UserDefaults.standard.string(forKey: "userEmail"))
            cell.imgMenu.image=UIImage(named:"grievances_user_image3.png")
            print(cell.lblTitle?.text);
            return cell;
         }
        else  if (indexPath.section==2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Thired");
            
            
            return cell!;
            
        }
        else  if (indexPath.section==3)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Fourth");
            
            
            return cell!;
            
        }
            
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Fifth")as! MenuTableViewCell;
            let objHomeMenu:HomeMenu = menuArray[indexPath.row];
            cell.lblTitle?.text=objHomeMenu.strMenu
            cell.imgMenu.image=UIImage(named:objHomeMenu.strImageName)
            print(cell.lblTitle?.text);
            return cell;
        }
            
        }
        else
        {
            if (indexPath.section==0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "First");
                
                
                return cell!;
                
            }
            else  if (indexPath.section==1)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Second")as! MenuTableViewCell;
                let objHomeMenu:HomeMenu = menuArray[indexPath.row];
                cell.lblTitle?.text="Login / Signup"
                cell.lblSubTitle?.text="for Personilize access"
                cell.imgMenu.image=UIImage(named:"grievances_user_image3.png")
                print(cell.lblTitle?.text);
                return cell;
                
                
                
                
            }
            else  if (indexPath.section==2)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Fourth");
                
                
                return cell!;
                
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Fifth")as! MenuTableViewCell;
                let objHomeMenu:HomeMenu = menuArray[indexPath.row];
                cell.lblTitle?.text=objHomeMenu.strMenu
                cell.imgMenu.image=UIImage(named:objHomeMenu.strImageName)
                print(cell.lblTitle?.text);
                return cell;
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var navigationController:UINavigationController;
      
        if (UserDefaults.standard.integer(forKey: "id")==0)
        {
        if indexPath.section==1
        {
            let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController = UINavigationController(rootViewController: Loginvc)
            
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
          
            self.revealViewController().rightRevealToggle(animated: true)
            self.revealViewController() .setFront(navigationController, animated: true)
        }
        if indexPath.section==3
        {
            if indexPath.row==0
            {
                let vcBusStopViewController = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController

                 navigationController = UINavigationController(rootViewController: vcBusStopViewController)
                
                let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationController.navigationBar.barStyle = .default
                
                navigationController.navigationBar.tintColor = UIColor.white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                
                
                
                self.revealViewController().rightRevealToggle(animated: true)
                self.revealViewController() .setFront(navigationController, animated: true)
            }
            else if indexPath.row==1
            {
                let vcDirectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
              navigationController = UINavigationController(rootViewController: vcDirectionViewController)
               
                
                let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationController.navigationBar.barStyle = .default
                
                navigationController.navigationBar.tintColor = UIColor.white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                
                self.revealViewController().rightRevealToggle(animated: true)
                self.revealViewController() .setFront(navigationController, animated: true)
            }
            else if indexPath.row==2
            {
                let vcFavoriteViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
                navigationController = UINavigationController(rootViewController: vcFavoriteViewController)
                
                
                let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationController.navigationBar.barStyle = .default
                
                navigationController.navigationBar.tintColor = UIColor.white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                self.revealViewController().rightRevealToggle(animated: true)
                self.revealViewController() .setFront(navigationController, animated: true)
            }
            else if indexPath.row==3
            {
                let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                navigationController = UINavigationController(rootViewController: Loginvc)
                
                let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationController.navigationBar.barStyle = .default
                
                navigationController.navigationBar.tintColor = UIColor.white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
               
                self.revealViewController().rightRevealToggle(animated: true)
                self.revealViewController() .setFront(navigationController, animated: true)
            }
            else if indexPath.row==4
            {
                let vcSOSViewController = self.storyboard?.instantiateViewController(withIdentifier: "SOSViewController") as! SOSViewController
                 navigationController = self.revealViewController().frontViewController as! UINavigationController
                let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationController.navigationBar.barStyle = .default
                
                navigationController.navigationBar.tintColor = UIColor.white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                
                let backItem = UIBarButtonItem()
                
                navigationItem.backBarButtonItem = backItem
                backItem.title = " "
                navigationController.pushViewController(vcSOSViewController,animated: false)
                self.revealViewController().pushFrontViewController(navigationController, animated: true)
               
                
                
               
            }
        }

        }
        else
        {
            if indexPath.section==1
            {
                let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
               // let navigationController:UINavigationController = UINavigationController(rootViewController: Loginvc)
                
                navigationController = UINavigationController(rootViewController: Loginvc)
                
                
                let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationController.navigationBar.barStyle = .default
                
                navigationController.navigationBar.tintColor = UIColor.white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                
                self.revealViewController().rightRevealToggle(animated: true)
                self.revealViewController() .setFront(navigationController, animated: true)
            }
            
            if indexPath.section==4
            {
                if indexPath.row==0
                {
                    let vcBusStopViewController = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
                    navigationController = UINavigationController(rootViewController: vcBusStopViewController)
                    
                    
                    let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                    navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                    navigationController.navigationBar.barStyle = .default
                    
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                    
                    self.revealViewController().rightRevealToggle(animated: true)
                    self.revealViewController() .setFront(navigationController, animated: true)
                }
                else if indexPath.row==1
                {
                    let vcDirectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
                    navigationController = UINavigationController(rootViewController: vcDirectionViewController)
                    
                    
                    let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                    navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                    navigationController.navigationBar.barStyle = .default
                    
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                    
                    self.revealViewController().rightRevealToggle(animated: true)
                    self.revealViewController() .setFront(navigationController, animated: true)
                }
                else if indexPath.row==2
                {
                    let vcFavoriteViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
                     navigationController = UINavigationController(rootViewController: vcFavoriteViewController)
                    
                    
                    let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                    navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                    navigationController.navigationBar.barStyle = .default
                    
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                    
                    self.revealViewController().rightRevealToggle(animated: true)
                    self.revealViewController() .setFront(navigationController, animated: true)
                }
                else if indexPath.row==3
                {
                    let vcGrivanceBaseViewController = self.storyboard?.instantiateViewController(withIdentifier: "GrivanceBaseViewController") as! GrivanceBaseViewController
                    navigationController = UINavigationController(rootViewController: vcGrivanceBaseViewController)
                    
                    
                    let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                    navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                    navigationController.navigationBar.barStyle = .default
                    
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                    
                    
                    self.revealViewController().rightRevealToggle(animated: true)
                    self.revealViewController() .setFront(navigationController, animated: true)
                }
                else if indexPath.row==4
                {
                    let vcSOSViewController = self.storyboard?.instantiateViewController(withIdentifier: "SOSViewController") as! SOSViewController
                    navigationController = self.revealViewController().frontViewController as! UINavigationController
                    let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
                    navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                    navigationController.navigationBar.barStyle = .default
                    
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
                    
                    //self.revealViewController().rightRevealToggle(animated: true)
                    //self.revealViewController() .setFront(navigationController, animated: true)
                    
                    let backItem = UIBarButtonItem()
                    
                    navigationItem.backBarButtonItem = backItem
                    backItem.title = " "
                    navigationController.pushViewController(vcSOSViewController,animated: false)
                    self.revealViewController().pushFrontViewController(navigationController, animated: true)
                }
                
                
               
            }
        }
        
    }
    
    @IBAction func btnLogOutBtnPressed(_ sender: AnyObject)
    {
        
        let alert = UIAlertController(title: "PMPML", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { action in
            UserDefaults.standard.set("", forKey: "userEmail")
            UserDefaults.standard.set("0", forKey: "userID")
            UserDefaults.standard.set("0", forKey: "id")
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "mobileNumber")
            
            let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationController:UINavigationController = UINavigationController(rootViewController: Loginvc)
            
            self.revealViewController().rightRevealToggle(animated: true)
            self.revealViewController() .setFront(navigationController, animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
     }

       @IBAction func btnLoginPressed(_ sender: Any)
    {
        if (UserDefaults.standard.integer(forKey: "id")==0)
        {
            let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
           let navigationController = UINavigationController(rootViewController: Loginvc)
            
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
            
            self.revealViewController().rightRevealToggle(animated: true)
            self.revealViewController() .setFront(navigationController, animated: true)
        }
        else
        {
            let vcRegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            let navigationController = UINavigationController(rootViewController: vcRegisterViewController)
            
            
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
            self.revealViewController().rightRevealToggle(animated: true)
            self.revealViewController() .setFront(navigationController, animated: true)
        }
        
    }
    @IBAction func btnBusTrackerPressed(_ sender: Any)
    {
        let vcBusStopViewController = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
        let  navigationController = UINavigationController(rootViewController: vcBusStopViewController)
        
        
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
        navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController.navigationBar.barStyle = .default
        
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        
        self.revealViewController().rightRevealToggle(animated: true)
        self.revealViewController() .setFront(navigationController, animated: true)
        
    }
    @IBAction func btnJornyPlannerPressed(_ sender: Any)
    {
        let vcDirectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
       let navigationController = UINavigationController(rootViewController: vcDirectionViewController)
        
        
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
        navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController.navigationBar.barStyle = .default
        
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        
        self.revealViewController().rightRevealToggle(animated: true)
        self.revealViewController() .setFront(navigationController, animated: true)
    }
    @IBAction func btnGrievancesPressed(_ sender: Any)
    {
        
            let vcGrivanceBaseViewController = self.storyboard?.instantiateViewController(withIdentifier: "GrivanceBaseViewController") as! GrivanceBaseViewController
            let navigationController = UINavigationController(rootViewController: vcGrivanceBaseViewController)
            
            
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
            
            self.revealViewController().rightRevealToggle(animated: true)
            self.revealViewController() .setFront(navigationController, animated: true)

        
    }
    
    
    @IBAction func btnSOSPressed(_ sender: Any)
    {
        let vcSOSViewController = self.storyboard?.instantiateViewController(withIdentifier: "SOSViewController") as! SOSViewController
        //let navigationController:UINavigationController = UINavigationController(rootViewController: Loginvc)
        //navigationController = UINavigationController(rootViewController: Loginvc)
       let navigationController = self.revealViewController().frontViewController as! UINavigationController
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
        navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController.navigationBar.barStyle = .default
        
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        backItem.title = " "
        navigationController.pushViewController(vcSOSViewController,animated: false)
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }

        @IBAction func btnOnlinePasspressed(_ sender: Any)
    {
        let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        let databsePathStr:String="http://pass.pmpml.org/"
        Loginvc.indexCount=1;
        Loginvc.loadPDF=2
        
        let urlwithPercentEscapes = databsePathStr.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        UIApplication.shared.openURL(NSURL(string: urlwithPercentEscapes!)! as URL)
        self.revealViewController().rightRevealToggle(animated: true)
      
    }
    @IBAction func btnPuneDarshanPressed(_ sender: Any)
    {
        let vcWebContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        vcWebContentViewController.databsePathStr="http://www.pmpml.org/pune-darshan/"
        vcWebContentViewController.indexCount=2;
        let navigationController = self.revealViewController().frontViewController as! UINavigationController
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
        navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController.navigationBar.barStyle = .default
        navigationController.navigationItem.title = "Pune Darshan";
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        backItem.title = " "
        navigationController.pushViewController(vcWebContentViewController,animated: false)
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }
    @IBAction func btnAiePortPressed(_ sender: Any)
    {
        let vcWebContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        vcWebContentViewController.databsePathStr="http://www.pmpml.org/online-airport-service/"
        vcWebContentViewController.indexCount=3;
        let navigationController = self.revealViewController().frontViewController as! UINavigationController
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
        navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController.navigationBar.barStyle = .default
        
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        
        //self.revealViewController().rightRevealToggle(animated: true)
        //self.revealViewController() .setFront(navigationController, animated: true)
        
        let backItem = UIBarButtonItem()
        
        navigationItem.backBarButtonItem = backItem
        backItem.title = " "
        navigationController.pushViewController(vcWebContentViewController,animated: false)
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }
    

    @IBAction func btnTimetablePressed(_ sender: Any)
    {
        /*let alert = UIAlertController(title: "Timetable", message: "Download Timetable for BRT and Non-BRT in PDF format", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "BRT", style: UIAlertActionStyle.default, handler: { action in
            
            let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
            Loginvc.databsePathStr="BRTSRoute"
            Loginvc.loadPDF=1;
            Loginvc.indexCount=4;
            let navigationController = self.revealViewController().frontViewController as! UINavigationController
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
            //self.revealViewController().rightRevealToggle(animated: true)
            //self.revealViewController() .setFront(navigationController, animated: true)
            
            let backItem = UIBarButtonItem()
            
            self.navigationItem.backBarButtonItem = backItem
            backItem.title = " "
            navigationController.pushViewController(Loginvc,animated: false)
            self.revealViewController().pushFrontViewController(navigationController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "NON BRT", style: UIAlertActionStyle.default, handler: { action in
            let Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
            Loginvc.databsePathStr="RegularBusService"
            Loginvc.loadPDF=1;
            Loginvc.indexCount=5;
            let navigationController = self.revealViewController().frontViewController as! UINavigationController
            let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            navigationController.navigationBar.barStyle = .default
            
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
            
            //self.revealViewController().rightRevealToggle(animated: true)
            //self.revealViewController() .setFront(navigationController, animated: true)
            
            let backItem = UIBarButtonItem()
            
           self.navigationItem.backBarButtonItem = backItem
            backItem.title = " "
            navigationController.pushViewController(Loginvc,animated: false)
            self.revealViewController().pushFrontViewController(navigationController, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)*/
        
        let vcWebContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        vcWebContentViewController.databsePathStr="Timetable"
        vcWebContentViewController.loadPDF=1;
        vcWebContentViewController.indexCount=4;
        let navigationController = self.revealViewController().frontViewController as! UINavigationController
        let image = UIImage.imageFromColor(color: UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1))
        navigationController.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController.navigationBar.barStyle = .default
        
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.barTintColor =  UIColor(red: 39/255, green: 57/255, blue: 129/255, alpha: 1)
        
        let backItem = UIBarButtonItem()
        self.navigationItem.backBarButtonItem = backItem
        backItem.title = " "
        navigationController.pushViewController(vcWebContentViewController,animated: false)
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
        
    }
    
    
}

extension UIImage{
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // create a 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}
