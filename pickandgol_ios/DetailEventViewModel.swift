//
//  DetailEventViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 27/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation

class DetailEventViewModel {
    
    let event:JSONDictionary
    let client = Client()
    let disposeBag = DisposeBag()
    
    init(eventDetail event:JSONDictionary){
        self.event = event
    }
    
    func getTitle() -> String {
        
        return event["name"] as! String
    }
    
    func getPhoto() -> Observable<UIImage> {
        return Observable<UIImage>.create { (observer) -> Disposable in
          
            if let imageCache = self.retrievePhoto(self.event["photo_url"] as! String){
                observer.onNext(imageCache)
                observer.onCompleted()
            } else{
                if let urlImage = URL(string: (self.event["photo_url"] as? String)!) {
                   
                    self.client.downloadImage(urlImage: urlImage).subscribe(
                        
                        onNext:{ result in
                            observer.onNext(result)
                            observer.onCompleted()
                    },
                        onError:{error in
                            print(error)
                    },
                        onCompleted: nil,
                        onDisposed: nil)
                        .addDisposableTo(self.disposeBag)
                    
                }else{
                    
                    observer.onNext(UIImage(named: "default_placeholder")!)
                    observer.onCompleted()
                    
                }
                

            }
            
            
            
         return Disposables.create()
        }
    }
    
    func getLocation() ->Observable<PubModel> {
        return Observable<PubModel>.create({ (observer) -> Disposable in
             let p = self.event["pubs"] as! NSArray
             self.client.getOnePub(pub: p[0] as! String).subscribe(
                onNext:{ result in
                    let data = result.result() as! JSONDictionary
                    let dataLocation = data["location"] as! JSONDictionary
                    let dataLocationCoordinates = dataLocation["coordinates"] as! NSArray
                    let gpsData = CLLocation(latitude:dataLocationCoordinates[1] as! CLLocationDegrees, longitude: dataLocationCoordinates[0] as! CLLocationDegrees)
                    let pub = PubModel(name: data["name"] as! String, location: gpsData)
                    observer.onNext(pub)
                    observer.onCompleted()
                    
             },
                onError:{error in
                    print(error)
             },
                onCompleted: nil,
                onDisposed: nil).addDisposableTo(self.disposeBag)
            
          return Disposables.create()  
        })
        
    }
        
        
        
    
    
    func getDescription() -> String {
        return event["description"] as! String
    }
    
    func getDate() -> String {
        return event["date"] as! String
    }
    
    func getCreator() -> String{
        return event["creator"] as! String
    }
    
    func getCategory() -> Int {
        return event["category"] as! Int
    }
    
    func retrievePhoto(_ namePhoto:String) -> UIImage? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let namePhoto = namePhoto.lastPathComponent
        let imageUrl = paths[0].appendingPathComponent(namePhoto)
        let image = UIImage(contentsOfFile: imageUrl.path)
        
        if image == nil {
            
        }
        return image
        
    }

    
    
}
