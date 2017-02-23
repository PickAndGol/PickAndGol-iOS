//
//  Client.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 21/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

public enum ClientError: Error {
    case couldNotDecodeJSON
    case badStatus(Int, String)
}



public class Client{
    
    
    
    let disposeBag = DisposeBag()

    func objects(endPoint:NetworkResource) -> Observable<[Response]> {
        
        return response(endPoint: endPoint)
            .map { response in
         
                print(response)
                guard let results:[Response] = response.results() else {
                    throw ClientError.couldNotDecodeJSON
                }
                return results
        }
        }
            
    private func response(endPoint:NetworkResource) ->Observable<Response>  {

        return Observable<Response>.create { (observer) -> Disposable in
        
        endPoint.request { (endPointResponse)   in
        
            if let value = endPointResponse as? JSONDictionary {
            
                 let response:Response = decode(value)!
                print(response)
                observer.onNext(response)
                observer.onCompleted()
                
                /*let datos = value["data"]?["items"] as! NSArray
            
                for dat in datos {
                    print("++++")
                    
                  
                   // print(response)
                    //print(dat as! JSONDictionary)
                    print("---")
                    
                }*/
            }
     
            }
            
        return  Disposables.create()
        }
        
            
        }
    
    
}
