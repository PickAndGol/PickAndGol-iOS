//
//  EventApiRespository.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 19/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class EventApiRepository {
    
    func listEvents(){
        
        let url = ApiPaths.event.url
        
      
        let client = Client()
        client.listAllEvent()
        /*let urlp = "http://www.mocky.io/v2/58ac684c1000002d12514b61"
                
        Alamofire.request(URL(string:urlp)!).responseJSON { (response) in
            print(response)
        }*/
        
    }
    
    
}
