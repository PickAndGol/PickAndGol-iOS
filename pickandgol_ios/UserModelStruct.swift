//
//  UserModelStruct.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation

struct UserModelStruct {

    let id: String
    let name: String
    let email: String
    let token:String?
    var photoUrl: String?
    let favorites: Array<Any> = Array()

    init(dictionary dict: JSONDictionary) throws {
        
        guard let id = dict["id"] as? String else {
            throw JSONDecodingError.wrongJSONFormat
        }
        guard let name = dict["name"] as? String else {
            throw JSONDecodingError.wrongJSONFormat
        }
        guard let email = dict["email"] as? String else {
            throw JSONDecodingError.wrongJSONFormat
        }
        
        if let token = dict["token"] as? String {
            self.token = token
        }else{
            self.token = nil
        }
        
        
        if let photoUrl = dict["photo_url"] as? String {
            self.photoUrl = photoUrl
        }else{
            self.photoUrl = nil
        }

        self.id = id
        self.name = name
        self.email = email
        
        
    }

}
