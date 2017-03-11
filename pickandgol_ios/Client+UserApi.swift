//
//  Client+UserApi.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 9/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

extension Client {
    
   
    public func recoverMail() -> Observable<Response>{
        let dictionary = ["email":"antonio@benavente-cardador.com"]
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/users/recover")!, method: .post, body: dictionary)
        
        return objects(endPoint: endpoint)
        
    }
    
    public func login() -> Observable<Response>{
        let dictionary = ["email":"antonio61@benavente-cardador.com","password":"password"]
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/users/login")!, method: .post, body: dictionary)
        
        return objects(endPoint: endpoint)
        
    }
    


}
