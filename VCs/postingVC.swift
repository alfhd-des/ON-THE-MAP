//
//  postingVC.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import UIKit
import MapKit

class postingVC: UIViewController {
    
    
    @IBOutlet weak var mediaURLTF: UITextField!
    @IBOutlet weak var locationNameTF: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var prepareLatitude : Double?
    var prepareLongitude : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mediaURLTF.delegate = self
        locationNameTF.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func findLocationClicked(_ sender: UIButton) {
        
        
        
        
        mediaURLTF.resignFirstResponder()
        locationNameTF.resignFirstResponder()
        
        guard let websiteLink = mediaURLTF.text else {return}
        
        let prefixOfwebsiteLinkFirst = String(websiteLink.prefix(7))
        let prefixOfwebsiteLinkSecond = String(websiteLink.prefix(8))
        
        
        
        let rangeCheckBool = (websiteLink.range(of:"http://") == nil ) || (websiteLink.range(of:"https://") == nil )
        let prefixCheckBool = (prefixOfwebsiteLinkFirst == "http://") || (prefixOfwebsiteLinkSecond == "https://")
        
        if  rangeCheckBool  &&  !prefixCheckBool {
            
            Helper.showAlert(withTitle: "OOOPS", body: "WRONG URL PROVIDED !", inVC: self)
            
            
        } else {
            if locationNameTF.text != "" && mediaURLTF.text != "" {
                
                indicator.startAnimating()
                
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = locationNameTF.text
                
                let activeSearch = MKLocalSearch(request: searchRequest)
                
                activeSearch.start { (response, error) in
                    
                    if error != nil {
                        self.indicator.stopAnimating()
                        
                        Helper.showAlert(withTitle: "OOOPS", body: "\(error?.localizedDescription ?? "")", inVC: self)
                        
                    } else {
                        self.indicator.stopAnimating()
                        self.prepareLatitude = response?.boundingRegion.center.latitude
                        self.prepareLongitude = response?.boundingRegion.center.longitude
                        self.performSegue(withIdentifier: "findLocationSegue", sender: nil)
                    }
                }
                
            }else {
                
                
                Helper.showAlert(withTitle: "OOOPS", body: "FILL DETAILS PLEASE", inVC: self)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "findLocationSegue" {
            
            let findTheLocation = segue.destination as! findLocationVC
            
            let currentStudentLocation = StudentLocations(objectId: nil, uniqueKey: nil, firstName: nil, lastName: nil, mapString: locationNameTF.text, mediaURL: mediaURLTF.text, latitude: prepareLatitude, longitude: prepareLongitude, createdAt: nil, updatedAt: nil)
            
            findTheLocation.passedStudentLocation = currentStudentLocation
            
        }
        
        
        
    }
    
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension postingVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
