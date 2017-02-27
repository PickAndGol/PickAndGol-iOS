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

    let disposeBag = DisposeBag()
    
    public func listOfEvent(){
        let client = Client()
        
        
        
        client.listAllEvent().subscribe(onNext: { (element) in
            print("DOS")
            print(element)
            
        }).addDisposableTo(disposeBag)
    
    
    
    }
}
