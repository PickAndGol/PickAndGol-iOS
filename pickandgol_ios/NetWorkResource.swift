//
//  NetWorkResource.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 20/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

public enum Method:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    
}

public enum TypeParameters:String {
    case body = "body"
}

public protocol NetworkResource {
    var path:URL { get }
}

extension NetworkResource {
    
    
    func request(completion:@escaping(_ response:Any) -> ()){
        
        //let urlp = "http://www.mocky.io/v2/58ac684c1000002d12514b61"
        let urlp = "http://www.mocky.io/v2/58bb30a11000001f01109e2f"
        Alamofire.request(URL(string:urlp)!).responseJSON { (response) in
            
            // Aquí no emite el valor devuelto
            
            switch response.result {
            case .success:
                completion(response.value)
            case .failure(let error):
                completion(error)
        }

        
    }
    
    }
    
    
}
