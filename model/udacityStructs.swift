//
//  udacityStructs.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//

import Foundation

struct loginRespons: Codable {
    
    let account: Account
    let session: Session
    
    
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration:String
}
