//
//  LogInOutStatus.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 29/02/24.
//

import Foundation

class LogManager{
    static let shared = LogManager()
    private let isLoggedInKey = "isLoggedIn"
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func setLoggedIn(_ loggedIn: Bool){
        UserDefaults.standard.set(loggedIn, forKey: isLoggedInKey)
    }
    
    func logout(){
       // UserDefaults.standard.removeObject(forKey: isLoggedInKey)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
}
