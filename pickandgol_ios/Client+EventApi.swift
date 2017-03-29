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
    
    public func listEvent(params:String) -> Observable<[JSONDictionary]>{
        
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/events/?"+params)!, method: .get, body: [:])
        
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            
            
            self.objects(endPoint: endpoint).subscribe(onNext: { (element) in
                
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
                
            }).addDisposableTo(self.disposeBag)
            
            
            
            return Disposables.create()
        }
        
    
        
    }

    
    public func saveEvent(dic:JSONDictionary) -> Observable<Response> {
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/events/")!, method: .post, body:dic as! bodyType)
        return objects(endPoint: endpoint)
    }
    
  
    
}
