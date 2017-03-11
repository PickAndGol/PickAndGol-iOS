//
//  userSessionManager.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation

class userSessionManager {
    
    var userSession:UserModelStruct?
    var logged:Bool = false
    static let sharedInstance = userSessionManager()
    
    private init(){
        
    }
    
    public func initWithLogin(dict:JSONDictionary){
        userSession = try! UserModelStruct(dictionary: dict)
        logged = true
    }
    
    public func getToken() -> String {
        return (userSession?.token)!
    }
    
    public func getUser() -> String {
        return (userSession?.name)!
    }
    
    public func getEmail() -> String {
        return (userSession?.email)!
    }
}
