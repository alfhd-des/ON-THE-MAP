//
//  APIsClient.swift
//  On The Map
//
//  Created by Fares Alharbi on 5/26/19.
//  Copyright © 2019 Fares Alharbi. All rights reserved.
//


import Foundation

class APIsClient {
    
    
    enum Endpoits {
        
        case allStudentsLocations
        case postStudentLocation
        case updateStudentLocation(String)
        case session
        case getUserDate(String)
        
        
        
        var stringValue : String {
            
            switch self {
                
            case .allStudentsLocations: return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .updateStudentLocation(let objectID): return "https://onthemap-api.udacity.com/v1/StudentLocation(\(objectID))"
            case .session: return "https://onthemap-api.udacity.com/v1/session"
            case .getUserDate(let userID): return "https://onthemap-api.udacity.com/v1/users/\(userID)"
            }
        }
        
        
        var url : URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func getStudentsLocations(compeletion: @escaping ([StudentLocations]?) ->()){
        
        
        var request = URLRequest(url: Endpoits.allStudentsLocations.url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            
            print(String(data: data!, encoding: .utf8)!) // <<<< this line print the whole data successfully !!!!!

//            let decoder = JSONDecoder()
            
            do {
//                let studentsLocation = try decoder.decode([StudentLocations].self, from: data!)
                
                let result = try JSONDecoder().decode(Result.self, from: data!)
                compeletion(result.results)
                
                print("in decoder")
//                compeletion(studentsLocation)
            } catch {
                 print("catch block of decoder")
                
            }
            
        }
        task.resume()
        
        
    }
    
    
    class func postStudentLocation(student : StudentLocations, compeletion: @escaping (StudentLocations?, Error?)->()){
        
        var request = URLRequest(url: Endpoits.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey ?? "")\", \"firstName\": \"\(student.firstName ?? "FARES")\", \"lastName\": \"\(student.lastName ?? "ALFHD")\",\"mapString\": \"\(student.mapString ?? "")\", \"mediaURL\": \"\(student.mediaURL ?? "")\",\"latitude\": \(student.latitude ?? 0.0 ), \"longitude\": \(student.longitude ?? 0.0 )}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                compeletion(nil,error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            let result = try! JSONDecoder().decode(StudentLocations.self, from: data!)
            compeletion(result,nil)
        }
        task.resume()
        
    }
    
    class func updateStudentLocation(objectID: String){
        
        let url = Endpoits.updateStudentLocation(objectID).url
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
        
    }
    
    class func getSessionID(userName:String, password:String, compeletion: @escaping (_ success:Bool?,
                                                                                      _ data:Data?,
                                                                                      _ error:Error?)->()){
        
        
        var request = URLRequest(url: Endpoits.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                
                compeletion(false,nil,error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
             compeletion(true,newData,nil)
        }
        task.resume()
    }
    
    class func deleteSession(compeletion: @escaping (_ success:Bool?,_ key:String?,_  error:Error?)->()){
        
        
        var request = URLRequest(url: Endpoits.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                compeletion(nil, nil, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
    
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                compeletion(false, "", error)
                return
            }
            if statusCode >= 200  && statusCode < 300 {
                
                //Skipping the first 5 characters
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                
                //Print the data
                print (String(data: newData!, encoding: .utf8)!)
                
                let json = try! JSONSerialization.jsonObject(with: newData!, options: []) as? [String : Any]
                
                //Get the unique key of the user
                let accountDictionary = json? ["account"] as? [String : Any]
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                 compeletion(true, uniqueKey, nil)
            } else {
                compeletion(false, "", nil)
            }
            
        
            
        }
        task.resume()
        
    }
    
    class func getUserData(userID : String){
        
        
        let request = URLRequest(url: Endpoits.getUserDate(userID).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
}

