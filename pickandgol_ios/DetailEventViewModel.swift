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
    var addressEvent = PublishSubject<String>()
    
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
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double)  {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country ?? "No def")
                    print(pm.locality ?? "No def")
                    print(pm.subLocality ?? "No def")
                    print(pm.thoroughfare ?? "No def")
                    print(pm.postalCode ?? "No def")
                    print(pm.subThoroughfare ?? "No def")
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        //addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                self.addressEvent.onNext(addressString)
                    
                }
        })
        
        
    }
        
        
        
    
    
    func getDescription() -> String {
        return event["description"] as! String
    }
    
    func getDate() -> String {
        let dateEvent = event["date"] as! String
        return dateEvent.zuluToDate()
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
