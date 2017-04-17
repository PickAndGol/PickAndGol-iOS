//
//  userSessionManager.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import Firebase

class userSessionManager {
    
    var userSession:UserModelStruct?
    var logged:Bool = false
    static let sharedInstance = userSessionManager()
    
    private init(){
        
    }
    
    public func initWithLogin(dict:JSONDictionary){
        
        logged = true
        
        do {
            userSession = try UserModelStruct(dictionary: dict)
        } catch {
            //MARK: - if before is logged put all var to nil
           logged = false
           userSession = nil
        }
        
        
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
    
    public func getUrlPhoto() -> String?{
        guard (userSession?.photoUrl) != nil else{
            return nil
        }
        return (userSession?.photoUrl)!
    }
    
    public func getIdUser() -> String {
        return (userSession?.id)!
    }
    
    public func setUrlPhoto(url:String) {
        self.userSession?.photoUrl = url
    }
    public func getTokenFirebase() -> String?{
        guard let refreshedToken = FIRInstanceID.instanceID().token() else{
            return nil
        }
        return refreshedToken

    }
    
    
    
    
}
