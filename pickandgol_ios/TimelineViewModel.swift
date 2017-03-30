//
//  TimelineViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TimelineViewModel {
    
    private let client: Client
    
    
    
    init(client: Client = Client()) {
        self.client = client
        
    }

    let disposeBag = DisposeBag()
    var query = Variable<(String)>("")
    
        
    
    private(set) lazy var eventsPubs:Observable<[JSONDictionary]> = self.query.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .flatMapLatest { query in
            
            return self.client.listEvent(params: "text="+query)
        }
        .observeOn(MainScheduler.instance)
        
  

    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    
    
    public func refreshTable() {
    
      eventsPubs = Observable.concat(eventsPubs,eventsPubs)
    
    }
    

 
    
   
    
    
}
