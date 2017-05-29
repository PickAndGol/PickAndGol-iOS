//
//  NewPubViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RealmSwift
import RxRealm


class NewPubViewModel: NSObject {
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    let posicion = CLLocationManager()
    var locationUser:CLLocation?
    let client = Client()
    
    let refreshTableListofPub = SelectPubViewModel()
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    let dataPub = PubModelRealm()
    
    
    
    override init(){
        super.init()
        // Create initial Pub without data
        addInitPhoto()
        bindRx()
        
    }
    
    
    func initLocationUser(){
        posicion.requestAlwaysAuthorization()
        posicion.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        
        // Compruebo si tengo acceso a la localización
        
        if (!(status == CLAuthorizationStatus.denied) ){
            
            // Configuro el location manager
            
            posicion.delegate = self
            posicion.desiredAccuracy = kCLLocationAccuracyBest
            
            // Empieza a funcionar
            posicion.startUpdatingLocation()
            
            
            
        }else{
            print("No tienes autorizacion para ejecutar Location Manager")
        }
        
    }
    
    func savePub(name:String, url:String, phone:String) -> Observable<JSONDictionary> {
    
        return Observable<JSONDictionary>.create{ (observer) -> Disposable in
        
            let pub = PubModel(namePub: name, location: self.locationUser!, weburl:url,phone:phone,photo:self.listOfPhotosFromPub())
            self.client.savePub(dic: pub.modelToDict()! as JSONDictionary).subscribe( onNext: { (element) in
            
                if (element.status == "ERROR"){
                    let error = element.getErrorFromPayload()
                    let errorDescriptionPub = error["description"]
                    let dict:JSONDictionary =  ["description":errorDescriptionPub!,"result":"nok" as AnyObject]
                    observer.onNext(dict)
                }else{
                    self.dataPub.name = name
    
                    try! self.realm.write {
                        self.realm.add(self.dataPub)
                    }
                    let dict:JSONDictionary = ["description":"Pub \(name) is saved" as AnyObject,"result":"ok" as AnyObject]
                    observer.onNext(dict)
                    
                 }
            
            }).addDisposableTo(self.disposeBag)
         return Disposables.create()
        }
    }
    
    /*func savePubD(_ dataPub:JSONDictionary){
        
        let realm = try! Realm()
        var data = dataPub
        data["location"] = locationUser
        let pub = PubModel(data: data)
        client.savePub(dic: pub.modelToDict()! as JSONDictionary).subscribe( onNext: { (element) in
            
            let dataPubRealm = PubModelRealm()
            
            dataPubRealm.name = data["name"] as! String
            
            
            
            try! realm.write {
                realm.add(dataPubRealm)
            }
            
        }).addDisposableTo(disposeBag)
        
        
    }*/
    
    func listOfPhotosFromPub()  -> String {
        var listPhotos = ""
        let bottomPhoto = dataPub.photos.last
        dataPub.photos.removeLast()
        dataPub.photos.remove(objectAtIndex: 0)
        
        for photo in dataPub.photos {
            listPhotos+=photo.photo+","
            
        }
        listPhotos += (bottomPhoto?.photo)!
        return listPhotos
    }
    
    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    
    func addInitPhoto(){
        let photoPub = PubModelPhotoRealm()
        
        // Delete all photo dummy
        
        photoPub.photo = "dummmy"
        try! realm.write {
            realm.add(photoPub)
        }
        
        dataPub.photos.append(photoPub)
        
    }
    
    func numOfPhotos() -> Int {
        
        return self.dataPub.photos.count
    }
    
    func photoAtIndex(_ index:Int) -> String {
        return self.dataPub.photos.toArray()[index].photo
    }
    
    func savePhoto(_ namePhoto:String) {
        
        let photoPub = PubModelPhotoRealm()
        
        photoPub.photo = namePhoto
        try! realm.write {
            realm.add(photoPub)
        }
        
        dataPub.photos.append(photoPub)
        
    }
    
    
    func bindRx(){
        
        //Observable<Results<PubModelPhotoRealm>>.changeset(from: <#T##Results<PubModelPhotoRealm>#>)
        
    }
    
    
    
   
    
    
}

extension NewPubViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        // Paramos que siga buscando la localiación. Consume mucha bateria
        
        self.posicion.stopUpdatingLocation()
        locationUser = latestLocation
        
        
        
        
    }
    
}
