//
//  Google PlaceViewController.swift
//  BusTrackingSystem
//
//  Created by Swapnil Mashalkar on 18/05/17.
//  Copyright © 2017 Aarya Tech. All rights reserved.
//

import UIKit
import GooglePlaces
protocol passtoDirectioViewController
{
    func SendAddress(isSource:Bool,Value:String,lat:Double,lon:Double)
}


class Google_PlaceViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var subView:UIView?
    var isSource = Bool()
    var delegate:passtoDirectioViewController! = nil
    //let Destination = NSString()
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       navigationController?.navigationBar.isTranslucent = false
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        //self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        
        subView = UIView(frame: CGRect(x: 0, y: 0.0, width:self.view.frame.size.width, height: 45.0))
        
        subView?.addSubview((searchController?.searchBar)!)
        view.addSubview(subView!)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        // Do any additional setup after loading the view.
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



extension Google_PlaceViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = true
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        
        dismiss(animated: true, completion: nil)
        
        delegate.SendAddress(isSource:isSource, Value: place.name, lat: lat, lon: lon)
        let _ = self.navigationController?.popViewController(animated: true)
        

        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}



