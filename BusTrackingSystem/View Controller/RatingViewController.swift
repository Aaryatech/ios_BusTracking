//
//  RatingViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 26/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol RatingView
{
    func RemoveRatingView(isStatusChange:Bool)
}

class RatingViewController: UIViewController,UITextViewDelegate {
@IBOutlet weak var ratingview: HCSStarRatingView!
    @IBOutlet weak var viwMain: UIView!
    @IBOutlet weak var scravoidscrollview: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var imgbackground: UIImageView!
     @IBOutlet weak var lblStatus: UILabel!
     @IBOutlet weak var txtSuggestion:UITextView!
    @IBOutlet weak var viwBorder:LBorderView!
    let recognizer = UITapGestureRecognizer()
    var rating:Int=0
    var issueId:Int = 0
    var customerRating:Int = 0
     var delegate:RatingView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        scravoidscrollview.isUserInteractionEnabled = true
        recognizer.addTarget(self, action: #selector(SharedViewController.BackgroungImageBeenTapped))
        scravoidscrollview.addGestureRecognizer(recognizer)
        
        
        
        
        viwBorder.cornerRadius = 8;
        
        
        viwBorder.frame = CGRect(x: self.viwMain.frame.origin.x, y: viwBorder.frame.origin.y, width: self.viwMain.frame.size.width-40, height: viwBorder.frame.size.height)
        viwBorder.borderType = BorderTypeDashed;
        viwBorder.borderWidth = 0.5;
        viwBorder.borderColor = UIColor.lightGray
        viwBorder.dashPattern = 6;
        viwBorder.spacePattern = 6;
        ratingview.minimumValue=0
        ratingview.maximumValue=5
        ratingview.value=0
        ratingview.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.touchUpInside)
        txtSuggestion.isEditable = true;
        txtSuggestion.selectedRange = NSMakeRange(2, 0);
        //ratingview.addTarget(self, action: #selector(Like) for:UIControlEvents.valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    func BackgroungImageBeenTapped()
    {
        print("image tapped")
        self.delegate.RemoveRatingView(isStatusChange: false)
        self.view!.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    
    func switchChanged(mySwitch: HCSStarRatingView)
    {
        print("Changed rating to %.1f", mySwitch.value)
        if mySwitch.value > 4
        {
            lblStatus.text = "Excellent"
        }
       else if mySwitch.value > 3
        {
             lblStatus.text = "Very Good"
        }
       else if mySwitch.value > 2
        {
            lblStatus.text = "Good"
        }
       else if mySwitch.value > 1
        {
            lblStatus.text = "Average"
        }
        else
        {
        lblStatus.text = "Poor"
        }
        rating =  Int(mySwitch.value)
       //lblStatus.text = String(describing: mySwitch.value as CGFloat)
        // Do something
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnSendFeedbackPressed(_ sender: Any)
    {
        txtSuggestion.resignFirstResponder()
        if(rating > 0)
        {
         Satisfactory()
        }
        else
        {
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.makeToast(message:"Please provide your Feedback in terms of Star Ratings!")
        }
        
    }
    
    
    func Satisfactory()
    {
        
        
        
        let  parameters = ["issueID": issueId,"customerRating": customerRating,"feedbackDescription": txtSuggestion.text,"isReopened": "false"] as [String : Any]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.client.invokeAPI("municipality/SetIssueFeedback", body: nil, httpMethod: "put", parameters: parameters, headers: nil)
        {
            (result, response, error) -> Void in
            if let err = error {
                print("ERROR ", err)
            }
            else if (result != nil)
            {
                
                //print("Todo Item: ",dict["email"]!)
                self.delegate.RemoveRatingView(isStatusChange: true)
                self.view.removeFromSuperview();
                // Do something with result
            }
        }
        
        
        
        
    }
    
    
    @IBAction func btnClose(_ sender: Any)
    {
        self.delegate.RemoveRatingView(isStatusChange: false)
        self.view.removeFromSuperview();
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
