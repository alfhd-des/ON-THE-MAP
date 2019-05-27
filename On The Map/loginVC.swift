//
//  loginVC.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import UIKit
import SafariServices

class loginVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        indicator.startAnimating()
        APIsClient.getSessionID(userName: emailTF.text! , password: passwordTF.text!, compeletion: handlLoginResponse(success:data:error:))
    }
    
    @IBAction func doNotHaveAccountClicked(_ sender: UIButton) {
        
        
        openSafariForRegistation()
        
    }
    
    func openSafariForRegistation(){
        
        let safariVC = SFSafariViewController(url: URL(string: "https://auth.udacity.com/sign-up")!)
        present(safariVC, animated: true, completion: nil)
        
        
    }
    
    func handlLoginResponse(success:Bool?, data:Data?, error:Error?){
        
        DispatchQueue.main.async {
            
            
            
            
            self.indicator.stopAnimating()
            
            if error != nil {
                Helper.showAlert(withTitle: "ERROR OCCURED", body: "\(error?.localizedDescription ?? "" )", inVC: self)
                return }
            if !success! {
                Helper.showAlert(withTitle: "COULD NOT MAKE THE CONNECTION", body: "", inVC: self)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let respons = try decoder.decode(loginRespons.self, from: data)
                
                if respons.account.registered {
                    
                    self.performSegue(withIdentifier: "studentsLocationsSegue", sender: self)
                    //                 Helper.showAlert(withTitle: "HI AND WELCOME BACK !", body: "", inVC: self)
                } else {
                    Helper.showAlert(withTitle: "WRONG CREDINTIALS", body: "", inVC: self)
                    
                }
                
                print("data \(respons)")
                
            } catch {
                Helper.showAlert(withTitle: "WRONG CREDINTIALS", body: "", inVC: self)
                print("could not find respons ") }
            
            
            
        }
    }
    
    
}


extension loginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
