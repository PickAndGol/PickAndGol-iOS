//
//  NewEventViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 12/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewEventViewModel{


    let client = Client()
    let disposeBag = DisposeBag()
   
    
    
    func saveEvent(dictionary dic:JSONDictionary){
        
        client.saveEvent(dic: dic).subscribe( onNext: { (element) in
            print(element)
            })

        
    }
    
    

}

