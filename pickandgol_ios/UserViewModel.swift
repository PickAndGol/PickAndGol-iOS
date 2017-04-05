//
//  UserViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 11/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import SwifterSwift


class UserViewModel{

    let disposeBag = DisposeBag()
    let client = Client()
    
    public func saveProfileUser(user:String, userEmail:String, userPhoto:UIImage){
        
        let body: [String : Any] = [
            "email": userEmail,
            "name": user,
            "token": userSessionManager.sharedInstance.getToken(),
            "photo_url": S3ConfigSingleton.sharedInstance.urlBucket.absoluteString+(userEmail.base64Encoded)!+".jpg"
        ]
    
        
        userPhoto.scaled(toWidth: CGFloat(200.0))?
            .savePhotoJPG((userEmail.base64Encoded)!+".jpg")?
            .savePhotoS3((userEmail.base64Encoded)!+".jpg").subscribe(onNext: { (element) in

                print(element)
                
            }).addDisposableTo(disposeBag)
        
        client.updateProfileUser(dictionary: body as JSONDictionary, idUser: userSessionManager.sharedInstance.getIdUser()).subscribe(onNext: {(element) in
            
            print(element)
            
            
        }).addDisposableTo(self.disposeBag)
        
    }
    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    
    func retrievePhoto(_ namePhoto:String) -> UIImage? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let namePhoto = namePhoto.lastPathComponent
        let imageUrl = paths[0].appendingPathComponent(namePhoto)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
        
    }
    
    
}
