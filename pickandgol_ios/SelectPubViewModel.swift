//
//  SelectPubViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 24/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

class SelectPubViewModel {
    
    private let client: Client
    
    init(client: Client = Client()) {
        self.client = client
    }
    
    let disposeBag = DisposeBag()
    
    public func listOfPub()->Observable<[JSONDictionary]>{
        
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            
            
            self.client.ListAllPub().subscribe(onNext: { (element) in
                
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
                
            }).addDisposableTo(self.disposeBag)
            
            
            
            return Disposables.create()
        }
        
        
        
        
        
    }
    
}
