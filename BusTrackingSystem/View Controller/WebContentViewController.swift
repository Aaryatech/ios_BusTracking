//
//  WebContentViewController.swift
//  BusTrackingSystem
//
//  Created by Aarya Tech on 07/07/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class WebContentViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var databsePathStr:String = "";
    var loadPDF:Int=0
    var indexCount:Int=0;
    override func viewDidLoad() {
        super.viewDidLoad()

        let activityData = ActivityData()
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        //
        
        if indexCount==1
        {
          self.navigationItem.title = "Online Passs";
        }
        else if indexCount==2
        {
        self.navigationItem.title = "Pune Darshan";
        }
        else if indexCount==3
        {
            self.navigationItem.title = "Airport";
        }
        else if indexCount==4
        {
            self.navigationItem.title = "Timetable";
        }
        else if indexCount==5
        {
            self.navigationItem.title = "Non BRT Timetable";
        }
        if loadPDF==1
        {
            if let pdf = Bundle.main.url(forResource: databsePathStr, withExtension: "pdf", subdirectory: nil, localization: nil)  {
                let req = NSURLRequest(url: pdf)
                webView.loadRequest(req as URLRequest)
                webView.scalesPageToFit=true;
            }
        }
        else
        {
        print(databsePathStr)
        let urlwithPercentEscapes = databsePathStr.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL (string:urlwithPercentEscapes!)
        let requestObj = NSURLRequest(url: url!)
        webView.loadRequest(requestObj as URLRequest)
        webView.delegate=self;
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidStartLoad(_ webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("AA")
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
         print("BB")
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
