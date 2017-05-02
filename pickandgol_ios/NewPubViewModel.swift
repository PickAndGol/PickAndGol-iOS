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


class NewPubViewModel: NSObject {
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    let posicion = CLLocationManager()
    var locationUser:CLLocation?
    let client = Client()
    
    let refreshTableListofPub = SelectPubViewModel()
    
    let disposeBag = DisposeBag()
    
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
    
    func savePub(_ name:String){
        
        let realm = try! Realm()
        
        let pub = PubModel(name: name, location: locationUser!)
        client.savePub(dic: pub.modelToDict()! as JSONDictionary).subscribe( onNext: { (element) in
            
            let dataPub = PubModelRealm()
            dataPub.name = name
            
            try! realm.write {
                realm.add(dataPub)
            }
            
        }).addDisposableTo(disposeBag)

        
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
