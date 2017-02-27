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
        
        // Falta pasarle los parametros
        return objects(endPoint: EventApi())
        
    }
    
}
