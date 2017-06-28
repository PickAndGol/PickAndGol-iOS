//
//  fileManager.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 19/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift
import RxSwift


extension UIImage {

    
    func savePhotoPNG(_ namePhoto:String){
    
        if let data = UIImagePNGRepresentation(self) {
            let paths = URL(fileURLWithPath: NSTemporaryDirectory())
            let documentsDirectory = paths
            let namePhoto = documentsDirectory.appendingPathComponent(namePhoto)
            do{
               try data.write(to: namePhoto)
            } catch {
                print("Error")
            }
           
        }
    }
    
    func savePhotoJPG(_ namePhoto:String) -> UIImage?{
        
        if let data = UIImageJPEGRepresentation(self, 0.9) {
            let paths = URL(fileURLWithPath: NSTemporaryDirectory())
            let documentsDirectory = paths
            let namePhoto = documentsDirectory.appendingPathComponent(namePhoto)
            do{
                try data.write(to: namePhoto)
               
            } catch {
                print("Error")
            }
            
        }
        
        return self
    }
    
    func savePhotoS3(_ namePhoto:String) ->Observable<Bool>{
        
        return Observable<Bool>.create({ (observer) -> Disposable in
            let client = Client()
            let disposeBag = DisposeBag()
            
            let paths = URL(fileURLWithPath: NSTemporaryDirectory())
            let documentsDirectory = paths
            let url = documentsDirectory.appendingPathComponent(namePhoto)
            
            client.uploadImage(pathFile: url).subscribe(
                
                onNext: { (element) in
                
                observer.onNext(true)
                observer.onCompleted()
                
            }).addDisposableTo(disposeBag)
            
            return Disposables.create()
        })
        
        
    }
    

    
    


}
