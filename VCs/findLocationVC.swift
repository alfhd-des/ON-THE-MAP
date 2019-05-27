//
//  findLocationVC.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import UIKit
import MapKit

class findLocationVC: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var passedStudentLocation : StudentLocations?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
        print("\n\n\n passed lat =\(passedStudentLocation?.latitude) \n passed long =\(passedStudentLocation?.longitude)")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createAnnotation()
    }
    
    
    @IBAction func finishClicked(_ sender: UIButton) {
        
        
        APIsClient.postStudentLocation(student: passedStudentLocation!, compeletion: handlPostStudentLocation(studentLocation:error:))
        
    }
    
    func handlPostStudentLocation(studentLocation: StudentLocations?,error:Error?){
        
        if error != nil {
            
            DispatchQueue.main.async {
                Helper.showAlert(withTitle: "OOOPS", body: "ERROR OCCURED \(error?.localizedDescription ?? "" )", inVC: self)
                
            }
            
        }
        
        DispatchQueue.main.async {
            
            if studentLocation == nil {
                
                let alert = UIAlertController(title: "OOOPS", message: "ERROR OCCURED", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                
                
            } else {
                
                let alert = UIAlertController(title: "DONE", message: "ADDED SUCCESSFULLY", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                print(" successded ")
            }
            
        }
        
        
        
        
    }
    
    func createAnnotation(){
        
        let annotation = MKPointAnnotation()
        annotation.title = passedStudentLocation?.mapString
        annotation.subtitle = passedStudentLocation?.mediaURL
        annotation.coordinate = CLLocationCoordinate2DMake((passedStudentLocation?.latitude)!, (passedStudentLocation?.longitude)!)
        mapView.addAnnotation(annotation)
        
        //Zoom to location
        
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake((passedStudentLocation?.latitude)!, (passedStudentLocation?.longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    
}


extension findLocationVC: MKMapViewDelegate {
    
    
    
    
    
    
    //delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
}
