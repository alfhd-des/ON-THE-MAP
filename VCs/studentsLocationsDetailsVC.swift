//
//  studentsLocationsDetailsVC.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import UIKit

class studentsLocationsDetailsVC: UIViewController {
    
    @IBOutlet weak var studentsLocationsTV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentsLocationsTV.delegate = self
        studentsLocationsTV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        studentsLocationsTV.reloadData()
    }
    
    
    func handleStudentsLocationsResponse(students: [StudentLocations]? ){
        
        
        guard let students = students else { return }
        
        globalStrudentsLocations = students
        
        DispatchQueue.main.async {
            self.studentsLocationsTV.reloadData()
            self.scrollToTop()
        }
        
        
        
    }
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.studentsLocationsTV.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func addStudentLocationClicked(_ sender: UIBarButtonItem) {
        
        let storyBoard = UIStoryboard(name: "posting", bundle: nil)
        let postingVC = storyBoard.instantiateInitialViewController()
        
        self.present(postingVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        
        APIsClient.getStudentsLocations(compeletion: handleStudentsLocationsResponse(students:))
        
        
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
    
    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        
        APIsClient.deleteSession(compeletion: handleLogoutResponse(success:key:error:))
        
    }
    
    
    
}

extension studentsLocationsDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if globalStrudentsLocations != nil {
            
            return globalStrudentsLocations!.count
            
        } else {
            
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell")
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "studentLocationCell")
        
        let currentStudentLocation = globalStrudentsLocations?[indexPath.row]
        if  currentStudentLocation != nil {
            cell.textLabel?.text = "\(currentStudentLocation?.firstName ?? "" ) \(currentStudentLocation?.lastName ?? "" )"
            cell.detailTextLabel?.text = currentStudentLocation?.mediaURL
            
            cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        }
        
        return cell
    }
    
    
    
    
    
    
}
