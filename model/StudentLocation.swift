//
//  StudentLocation.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//


import Foundation


struct Result : Codable {
    //includes all users data
    let results : [StudentLocations]?
}


struct StudentLocations : Codable {
    

    let objectId : String?
    let uniqueKey : String?
    let firstName : String?
    let lastName : String?
    let mapString : String?
    let mediaURL : String?
    let latitude : Double?
    let longitude : Double?
    let createdAt : String?
    let updatedAt : String?

    
}
