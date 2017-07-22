//
//  SharedViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 20/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import MessageUI

class SharedViewController: UIViewController,MFMessageComposeViewControllerDelegate
{
    @IBOutlet weak var lblBusPhysicalNumber: UILabel!
    @IBOutlet weak var lblSharedOn: UILabel!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStation: UILabel!
    @IBOutlet weak var lblBusName: UILabel!
    var strBusPhysicalNumber = ""
    var strSharedOn = ""
    var strStatus = ""
    var strStation = ""
    var strBusName = ""
    
    @IBOutlet weak var BackgroungImage: UIImageView!
    let recognizer = UITapGestureRecognizer()
    
    
    var urlString = String();
    override func viewDidLoad() {
        super.viewDidLoad()

        BackgroungImage.isUserInteractionEnabled = true
        
        //this is where we add the target, since our method to track the taps is in this class
        //we can just type "self", and then put our method name in quotes for the action parameter
        recognizer.addTarget(self, action: #selector(SharedViewController.BackgroungImageBeenTapped))
        
        //finally, this is where we add the gesture recognizer, so it actually functions correctly
        BackgroungImage.addGestureRecognizer(recognizer)
        lblBusName.text = strBusName
        lblStatus.text = "Running"
        lblStation.text = strStation
        lblBusPhysicalNumber.text = strBusPhysicalNumber
        lblSharedOn.text = strSharedOn
         urlString = "Route:\(lblBusName.text!) \n Bus Number:\(lblBusPhysicalNumber.text!) \n station:\(lblStation.text!) \n Status:\(lblStatus.text!) \n Shared On:\(lblSharedOn.text!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BackgroungImageBeenTapped()
    {
        print("image tapped")
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }

    @IBAction func btnSmsPressed(_ sender: Any)
    {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = urlString
            controller.recipients = [""]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
            
        }
        else
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"can not able to send message")
            
        }
    }
    @IBAction func btnWhatsappPressed(_ sender: Any)
    {
        
        let urlStringEncoded = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.openURL(url! as URL)
            self.view!.removeFromSuperview()
            self.removeFromParentViewController()
        } else
        {
          
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"WhatsApp not Installed")
           
        }
    }
    func messageComposeViewController(_ didFinishWithcontroller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
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
