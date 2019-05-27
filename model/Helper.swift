//
//  Helper.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    class func showAlert(withTitle: String, body:String, inVC: UIViewController){
        
        let alert = UIAlertController(title: "\(withTitle)", message: "\(body)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        inVC.present(alert, animated: true, completion: nil)
        
    }
    

    
}
