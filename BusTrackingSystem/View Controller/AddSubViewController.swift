//
//  AddSubViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 24/06/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit

class AddSubViewController: UIViewController,UIGestureRecognizerDelegate {
@IBOutlet weak var imgBack: UIImageView!
    var tap = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        self.imgBack.isUserInteractionEnabled = true;
        self.imgBack.addGestureRecognizer(tap)
        tap.isEnabled = false
        // Do any additional setup after loading the view.
    }

    
    func tap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        
        self.view.removeFromSuperview();
        
    }
    @IBAction func btnRemovepressed(_ sender: Any)
    {
        self.view.removeFromSuperview();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
