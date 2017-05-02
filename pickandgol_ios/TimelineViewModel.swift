
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
    
    fileprivate let eventsSubject = PublishSubject<[JSONDictionary]>()
    fileprivate var eventsApi:[JSONDictionary] = []
    fileprivate var pageElement = 0
    static let limit = 10
    static let incrementElement = 10
    
    var events: Observable<[JSONDictionary]> {
        return eventsSubject.asObservable()
    }
    
    
    init(client: Client = Client()) {
        self.client = client
        
        self.query.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(
                onNext:{ value in
                     self.pageElement = 0
                     self.refreshTable(refresh: true)
                    
            }
        
        ).addDisposableTo(disposeBag)
        

        
        
    }

    let disposeBag = DisposeBag()
    var query = Variable<(String)>("")
    var refreshTableEvent = PublishSubject<Bool>()
    
    
    
    
    
    
    /*private(set) lazy var eventsPubs:Observable<[JSONDictionary]> = self.query.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .flatMapLatest { query in
            
            return self.client.listEvent(params: "text="+query)
        }
        .observeOn(MainScheduler.instance)
        
    */

    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    
    
    public func refreshTable(refresh:Bool=false) {
    
        let params = "text=\(query.value)&start=\(pageElement)&limit=\(TimelineViewModel.limit)"
        print(params)
        client.listEvent(params: params).subscribe(
        
            onNext:{ value in
                if (value.count > 0) {
                    if (refresh){
                        self.eventsApi.removeAll()
                        self.eventsSubject.onNext(self.eventsApi)
                      
                    }
                    
                    self.eventsApi.append(contentsOf: value)
                    self.eventsSubject.onNext(self.eventsApi)
                    self.pageElement += value.count
                    self.refreshTableEvent.onNext(true)
                }else {
                    self.eventsSubject.onCompleted()
                }
                print("TOTAL",self.eventsApi.count)
        }
        
        ).addDisposableTo(disposeBag)
        
    
    }
    
    
    

 
    
   
    
    
}
