//
//  Client+EventApi.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 21/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

extension Client {
    
    public func listAllEvent() -> Observable<Response>{
    
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/events/")!, method: .get, body: [:])
        return objects(endPoint: endpoint)
        
    }
    
    public func saveEvent() {
        
    }
    
    
    // Quitar de aqui y poner en Client+UserApi
    public func recoverMail() -> Observable<Response>{
        let dictionary = ["email":"antonio@benavente-cardador.com"]
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/users/recover")!, method: .post, body: dictionary)
    
        return objects(endPoint: endpoint)
    
    }
    
}
