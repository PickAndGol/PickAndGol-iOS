//
//  UserViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

class UserViewModel{

    
    let client = Client()

    func login(email:String, pass:String){
        
       let session = userSessionManager.sharedInstance
        
        client.login().subscribe( onNext: { (element) in
            session.initWithLogin(dict: element.result() as! JSONDictionary)
            
            //TODO: Pendiente de login erroneo y ui alert con el resultado
            
            
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
