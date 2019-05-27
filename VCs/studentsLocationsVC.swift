//
//  studentsLocationsVC.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import UIKit
import MapKit

var globalStrudentsLocations : [StudentLocations]?
class studentsLocationsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        APIsClient.getStudentsLocations(compeletion: handleStudentsLocationsResponse(students:))
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func handleStudentsLocationsResponse(students: [StudentLocations]? ){
        
        
        guard let students = students else { return }
        
        globalStrudentsLocations = students
        
        
        
        DispatchQueue.main.async {
            
            for student in students {
                self.addAnnotationFor(student: student)
            }
            
            
        }
        
    }
    
    func handleLogoutResponse(success:Bool?,key:String?,error:Error?){
        
        
        DispatchQueue.main.async {
            
            
            if error != nil {
                Helper.showAlert(withTitle: "OOOPS", body: "ERROR OCCURED WHILE LOGGING OUT \(error?.localizedDescription)", inVC: self)
                return
            }else if success == false {
                Helper.showAlert(withTitle: "OOOPS", body: "ERROR OCCURED WHILE LOGGING OUT", inVC: self)
            } else {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func addAnnotationFor(student: StudentLocations){
        
        
        
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = student.latitude
        let long = student.longitude
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        
        let first = student.firstName
        let last = student.lastName
        let mediaURL = student.mediaURL
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
        
        
    }
    
    @IBAction func addStudentLocationClicked(_ sender: UIBarButtonItem) {
        
        let storyBoard = UIStoryboard(name: "posting", bundle: nil)
        let postingVC = storyBoard.instantiateInitialViewController()
        
        self.present(postingVC!, animated: true, completion: nil)
    }
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        
        APIsClient.getStudentsLocations(compeletion: handleStudentsLocationsResponse(students:))
        
        
    }
    
    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        
        APIsClient.deleteSession(compeletion: handleLogoutResponse(success:key:error:))
    }
    
    
}
extension studentsLocationsVC: MKMapViewDelegate {
    
    
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    
}
