//
//  UserModelStruct.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation

struct UserModelStruct {

    let id: String
    let name: String
    let email: String
//    let photoUrl: String = nil
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
//        guard let photoUrl = dict["photo_url"] as? String else {
//            throw JSONDecodingError.wrongJSONFormat
//        }

        self.id = id
        self.name = name
        self.email = email
//        self.photoUrl = photoUrl
    }

}
