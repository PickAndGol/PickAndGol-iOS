//
//  LoginViewModel.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {

    let client = Client()
    
    func login(email:String, pass:String)->Observable<Bool> {
        
        return Observable<Bool>.create({ (observer) -> Disposable in
            let session = userSessionManager.sharedInstance
            self.client.login(email: email, password: pass).subscribe( onNext: { (element) in
                
                session.initWithLogin(dict: element.result() as! JSONDictionary)
                observer.onNext(session.logged)
                observer.onCompleted()
            })
            
            return  Disposables.create()
        })
        
        
    }
    
    
    
    
    
    
    func qualityPassword(val:String) -> UIColor {
        
        var color:UIColor
        
        switch(val.length){
            
        case 1..<2:
            color = UIColor.red
            
        case 2..<5:
            color = UIColor.orange
            
            
        default:
            color = UIColor.black
            
        }
        
        return color
        
        
        
    }
    
    
}
