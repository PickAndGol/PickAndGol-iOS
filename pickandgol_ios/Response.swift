//
//  Response.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 21/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation


public struct Response {
    
    public let status: String
    public let message: String
    fileprivate let payload: AnyObject
    
    public var succeeded: Bool {
        return status == "OK"
    }
    
    public func result<T: JSONDecodable>() -> T? {
        return (payload as? JSONDictionary).flatMap(decode)
    }
    // Me quedo por aqui la funcion no funciona correctamente
    public func results() -> [JSONDictionary]? {
        
        var dataInDictionary = [JSONDictionary]()
        let datos = payload["items"] as! NSArray
         
         for dat in datos {
         //print("++++")
         
         dataInDictionary.append(dat as! JSONDictionary)
         
         // print(response)
         //print(dat as! JSONDictionary)
         //print("---")
         
         }
        return dataInDictionary
    }
}

extension Response: JSONDecodable {
    
    public init?(dictionary: JSONDictionary) {
        
        let status = dictionary["result"] as? String
        let payload = dictionary["data"]
        /*guard
            let status = dictionary["result"] as? String,
            let message = dictionary["error"] as? String,
            let payload = dictionary["data"] else {
                return nil
        }*/
        
        self.status = status!
        self.message = "NO implementado"
        self.payload = payload ?? "" as AnyObject
    }
}
