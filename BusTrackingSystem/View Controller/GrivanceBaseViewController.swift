//
//  GrivanceBaseViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 16/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class GrivanceBaseViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RemoveRegisterGrivance,ChangeStatus {
var menuArray=NSMutableArray();
    var GreviancemenuArray=NSMutableArray();
    let objGrivance = GrivianceViewController();
    let objmygrivance = MyGrivianceViewController();
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var ShowSelectedMenuGrivance:Int = 0
    @IBOutlet weak var viwInner: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let Home1 = HomeMenu();
        Home1.strMenu="Bus Tracker";
        Home1.strImageName="bus_stop_ico.png";
        
        let Home2 = HomeMenu();
       Home2.strMenu="Planner";
        Home2.strImageName="direction_ico.png";
        
       
        
        
        let Home3 = HomeMenu();
        Home3.strMenu="Favroite";
        Home3.strImageName="favorite_ico.png";
        
        let Home4 = HomeMenu();
        Home4.strMenu="Grievances";
        Home4.strImageName="grievances_ico.png";
        
        
        menuArray=[Home1,Home2,Home3,Home4];
        
        let Home6 = HomeMenu();
        Home6.strMenu="Register";
        
        
        let Home7 = HomeMenu();
        Home7.strMenu="My Grievances";
       
        
        let Home8 = HomeMenu();
        Home8.strMenu="Track";
        GreviancemenuArray = [Home6,Home7,Home8];

        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GrivianceViewController") as! GrivianceViewController
        viewController.delegate = self
        viewController.view.frame = viwInner.bounds;
        viewController.willMove(toParentViewController: self)
        viwInner.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        
        
        
        
        
        
        btnMenu.target=revealViewController();
        btnMenu.action=#selector(SWRevealViewController.revealToggle(_:));
        
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBOutlet weak var clvGravianceMenu: UICollectionView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UIColletion DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView==clvGravianceMenu
        {
            return 1;
        }
        else
        {
        return 2;
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView==clvGravianceMenu
        {
          return 3;
        }
        else
        {
        if section==0 {
            return menuArray.count;
        }
        else
        {
            return 1;
        }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView==clvGravianceMenu
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grivanceMenu", for: indexPath)as! HomeMenuCollectionViewCell;
            let Home:HomeMenu=GreviancemenuArray[ indexPath.row] as! HomeMenu;
            cell.lnlMenuItem.text=Home.strMenu;
            if ShowSelectedMenuGrivance == indexPath.row
            {
                cell.viwShowSelectedGrivance.backgroundColor = UIColor.red
            }
            else
            {
            cell.viwShowSelectedGrivance.backgroundColor = UIColor.white
            }
            //cell.imgMenu.image = UIImage(named: Home.strImageName);
            return cell
        }
        else
        {
        if indexPath.section==0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenu", for: indexPath)as! HomeMenuCollectionViewCell;
            let Home:HomeMenu=menuArray[ indexPath.row] as! HomeMenu;
            cell.lnlMenuItem.text=Home.strMenu;
            cell.imgMenu.image = UIImage(named: Home.strImageName);
            
            if indexPath.row != 3
            {
                cell.lnlMenuItem.alpha = 0.4
                cell.imgMenu.alpha = 0.4
            }
            return cell
        }
        else
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenu1", for: indexPath)as! HomeMenuCollectionViewCell;
            cell.imgMenu.image = UIImage(named:"nav_ico.png");
            //cell.lnlMenuItem.alpha = 0.4
            cell.imgMenu.alpha = 0.4
            return cell
        }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView==clvGravianceMenu
        {
           
            if indexPath.row==0
            {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "GrivianceViewController") as! GrivianceViewController
               // viewController.delegate = self
                viewController.delegate = self
                viewController.view.frame = viwInner.bounds;
                viewController.willMove(toParentViewController: self)
                viwInner.addSubview(viewController.view)
                self.addChildViewController(viewController)
                viewController.didMove(toParentViewController: self)
                // Configure Child View
                 ShowSelectedMenuGrivance = indexPath.row;
            }
            else if indexPath.row==1
            {
                
                if (UserDefaults.standard.integer(forKey: "id")==0)
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.isCommingFromGrivance = 1
                    navigationController?.pushViewController(vc,animated: true)
                }
                else
                {
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MyGrivianceViewController") as! MyGrivianceViewController
                // viewController.delegate = self
                    
                    
                    
                 ShowSelectedMenuGrivance = indexPath.row;
                viewController.view.frame = viwInner.bounds;
                viewController.willMove(toParentViewController: self)
                viwInner.addSubview(viewController.view)
                self.addChildViewController(viewController)
                viewController.didMove(toParentViewController: self)
                // Configure Child View

                }
            }
            else if indexPath.row==2
            {
                if (UserDefaults.standard.integer(forKey: "id")==0)
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.isCommingFromGrivance = 1
                    
                    navigationController?.pushViewController(vc,animated: true)
                }
                else
                {

                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MyGrivianceViewController") as! MyGrivianceViewController
                // viewController.delegate = self
                    let backItem = UIBarButtonItem()
                    
                    navigationItem.backBarButtonItem = backItem
                    backItem.title = "Track Grievances"
                    
                viewController.ShowtrackGrivance = 1;
               // ShowSelectedMenuGrivance = indexPath.row;
                    navigationController?.pushViewController(viewController,animated: true)
                //viewController.view.frame = viwInner.bounds;
                //viewController.willMove(toParentViewController: self)
                
                //viwInner.addSubview(viewController.view)
                //self.addChildViewController(viewController)
                //viewController.didMove(toParentViewController: self)
                }
            }
            clvGravianceMenu.reloadData();
            
        }
        else
        {
        
        if indexPath.section==1
        {
            //self.navigationController?.setNavigationBarHidden(false, animated: true)
            // let revealViewController = SWRevealViewController()
            //revealViewController.rightRevealToggle(self)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            // revealViewController.revealToggle(animated: true)
            
            self.revealViewController().rightRevealToggle(animated: true)
            
            
            
        }
        else
        {
            if indexPath.row==1
            {
                let backItem = UIBarButtonItem()
                
                navigationItem.backBarButtonItem = backItem
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
                
                navigationController?.pushViewController(vc,animated: true)
                
            }
                
            else  if indexPath.row==0
            {
                let backItem = UIBarButtonItem()
                
                navigationItem.backBarButtonItem = backItem
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusStopViewController") as! BusStopViewController
                
                navigationController?.pushViewController(vc,animated: true)
                
            }
            else  if indexPath.row==2
            {
                let backItem = UIBarButtonItem()
                
                navigationItem.backBarButtonItem = backItem
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
                
                navigationController?.pushViewController(vc,animated: true)
                
            }
        }
        
      }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        // let paddingSpace = sectionInsets.left * (3 + 1)
        //let availableWidth = view.frame.width - paddingSpace
        if collectionView==clvGravianceMenu
        {
            let widthPerItem = view.frame.width / 3
            
            return CGSize(width: widthPerItem, height:45)
        }
        else
        {
        let widthPerItem = view.frame.width / 5.3
        
        return CGSize(width: widthPerItem, height:widthPerItem)
        }
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsetsMake(topMargin, left, bottom, right);
    }
    
    private func add(asChildViewController viewController: UIViewController)
    {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        viwInner.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = viwInner.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    func RemoveRegisterSubview()
    {
        ShowSelectedMenuGrivance=1
        clvGravianceMenu.reloadData()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyGrivianceViewController") as! MyGrivianceViewController
        // viewController.delegate = self
        viewController.view.frame = viwInner.bounds;
        viewController.willMove(toParentViewController: self)
        viwInner.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        
    }
    
     func PendingStatus(status:Int,objGrivance:MyGrivance )
     {
    
        if status==0
        {
           ShowSelectedMenuGrivance=1
            clvGravianceMenu.reloadData();
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyGrivianceViewController") as! MyGrivianceViewController
            // viewController.delegate = self
            viewController.view.frame = viwInner.bounds;
            viewController.willMove(toParentViewController: self)
            viwInner.addSubview(viewController.view)
            self.addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
            
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GrivanceDetailViewController") as! GrivanceDetailViewController
            let backItem = UIBarButtonItem()
            
            navigationItem.backBarButtonItem = backItem
            backItem.title = " "
            vc.delegate=self
            vc.iscommingfromBase = true
            vc.issueId = objGrivance.iIssueID
            // backItem.title = "Grievances Details"
            navigationController?.pushViewController(vc,animated: true)
        }
     }
    
    func ChaneStatusReflect()
    {
        ShowSelectedMenuGrivance=1
        clvGravianceMenu.reloadData();
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GrivianceViewController") as! GrivianceViewController
        viewController.delegate = self
        viewController.view.frame = viwInner.bounds;
        viewController.willMove(toParentViewController: self)
        viwInner.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
