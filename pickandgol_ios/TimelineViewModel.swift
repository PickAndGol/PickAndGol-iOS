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
    var query = Variable<String>("")
    
    
    private(set) lazy var eventsPubs:Observable<[JSONDictionary]> = self.query.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .flatMapLatest { query in
            
            return self.client.listEvent(params: "text="+query)
        }
        .observeOn(MainScheduler.instance)
        .shareReplay(1)
  

    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    
    
    
    
    /*public func listOfEvent()->Observable<[JSONDictionary]>{
        
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
        
        self.query.asObservable()
            /*.filter { query in
                // Ignore query strings with less that 3 characters
                query.characters.count > 2
            }*/ 
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest { query in
                
                return self.client.listEvent(params: "text="+query)
            }
            .observeOn(MainScheduler.instance)
            .shareReplay(1)
            .subscribe(onNext: { (element) in
                
               print(element)
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
                
                
            }).addDisposableTo(self.disposeBag)
    return Disposables.create()
    }
    
    
    }*/
    
    
    /*public func listOfEvent()->Observable<[JSONDictionary]>{
    
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            
            
            self.client.listAllEvent().subscribe(onNext: { (element) in
                
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
                
            }).addDisposableTo(self.disposeBag)
            
            
            
            return Disposables.create()
        }
        
    }*/
    
    
}
