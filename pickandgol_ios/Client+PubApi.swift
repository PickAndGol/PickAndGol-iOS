//
//  Client+PubApi.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

extension Client {
    
    
    public func savePub(dic:JSONDictionary) -> Observable<Response> {
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/pubs/")!, method: .post, body:dic as! bodyType)
        return objects(endPoint: endpoint)
    }
    
    public func ListAllPub() ->  Observable<[JSONDictionary]> {
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/pubs/")!, method: .get, body:[:])
       // return objects(endPoint: endpoint)
        
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            self.objects(endPoint: endpoint).subscribe(onNext: { (element) in
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
            }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
        
        
    }
    public func ListAllPub(params:String) -> Observable<Response> {
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/pubs/?"+params)!, method: .get, body:[:])
        return objects(endPoint: endpoint)
    }
    
    public func getOnePub(pub:String) -> Observable<Response> {
        let endpoint = EventApi(path: URL(string:"http://pickandgol.com/api/v1/pubs/"+pub)!, method: .get, body:[:])
        return objects(endPoint: endpoint)
    }
    
    
}
