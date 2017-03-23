//
//  touchIDAutentication.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 21/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift


class TouchIDAutentication {
    
    let context = LAContext()
    
    func isTouchIDPossible() ->Observable<Bool> {
        
        return Observable<Bool>.create({ (observer) -> Disposable in
            if (self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)) {
                observer.onNext(true)
            }else {
                observer.onNext(false)
            }
            observer.onCompleted()
            return Disposables.create()
        })
        
       
    }
    
    func autenticateWithTouchID() ->Observable<Bool> {
        
        return Observable<Bool>.create({ (observer) -> Disposable in
        
            if  (self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:nil)){
            
                self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login PickAndGol", reply: { (success, error) in
                
                    if (success) {
                    observer.onNext(true)
                    }
                
                    if (error != nil) {
                    observer.onNext(false)
                    }
                   observer.onCompleted()
                })
            
            }
        return Disposables.create()
        })
    }
    
    
    
}
