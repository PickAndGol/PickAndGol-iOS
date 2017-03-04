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
        
    //suggestions = client.listAllEvent().asObservable().observeOn(MainScheduler.instance)
        
    }

    let disposeBag = DisposeBag()
    
    //var suggestions: Observable<JSONDictionary>
    
    
    
    public func listOfEvent()->Observable<[JSONDictionary]>{
    
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            
            
            self.client.listAllEvent().subscribe(onNext: { (element) in
                
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
                
            }).addDisposableTo(self.disposeBag)
            
            
            
            return Disposables.create()
        }
        
        
        
        /*client.listAllEvent().subscribe(onNext: { (element) in
            print("DOS")
            print(element.results())
            print("FIN")
            
        }).addDisposableTo(disposeBag)*/
    
    
    
    }
}
