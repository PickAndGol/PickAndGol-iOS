//
//  MapEventViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 3/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import MapKit





class MapPubViewModel:NSObject {
    
    let client = Client()
    let disposeBag = DisposeBag()
    
    

    public func listCategory(radius:String, textFilter:String)->Observable<[MKAnnotation]>{
        
        return Observable<[MKAnnotation]>.create { (observer) -> Disposable in
            
            let pos = CurrentPositionUser.sharedInstance
            let paramsUrl = "xxxlatitude="+String(pos.getLatidude())+"&longitude="+String(pos.getLongitud())+"&radius="+radius+"&text="+textFilter
            self.client.ListAllPub(params:paramsUrl)
                .subscribe(onNext: { (elements) in
                    
                    var annotation = [MKAnnotation]()
                    for element in elements.results()! {
                        let infoLocation = element["location"] as! JSONDictionary
                        let coordinatePubInfo = infoLocation["coordinates"] as! NSArray
                        let coordinatePub = CLLocationCoordinate2D(latitude: coordinatePubInfo[0] as! CLLocationDegrees, longitude: coordinatePubInfo[1] as! CLLocationDegrees)
                        let annotationPub = MapsAnnotationsUtils(coordinate: coordinatePub, title: element["name"] as! String, subtitle: "")
                        annotation.append(annotationPub)
                    }
                observer.onNext(annotation)
                observer.onCompleted()
            }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
        
        
    }

    
    
}




