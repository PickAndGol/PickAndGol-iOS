//
//  SelectPubViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 24/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

class SelectPubViewModel {
    
    private let client: Client
    private let realm = try! Realm()
    private var start = 0
    private let limit = 20
    private var firstSuscriptionSearchBar = true
    var filterAction = false
    

    
    //var itemsPub = [JSONDictionary]()
    let refreshListOfPub = Variable<Bool>(false)
    let selectedPub = PublishSubject<String>()
    let listOfPubTable:Results<PubModelRealm>?
    var loadingDataServer = false
    
    let query = Variable("")
  
    
    
    init(client: Client = Client()) {
        self.client = client
        listOfPubTable = realm.objects(PubModelRealm.self)
        bindRx()
        listOfPub()
        
    }
    
    
    let disposeBag = DisposeBag()
    
  
    
    public func listOfPub(addRegister:Bool = true) {
        
        var params = ("offset=\(start)&limit=\(limit)")
        
       if(query.value != ""){
            params+="&text="+query.value
        }
 
    
        self.client.ListAllPub(params:params).subscribe(onNext: { (element) in
            
            let returnElement = (element.results()?.count)!
            
            if(!addRegister){
              self.deleteAllRegisterInPubModelRealm()
            }else{
                self.start += self.start+returnElement
            }
            if ( returnElement > 0 ){
                self.saveDataInPubModelRealm(dataPub: element.results()!)
            }
            
            
        }).addDisposableTo(self.disposeBag)
        
        
    }
    
    public func numOfPub() -> Int {
        return (listOfPubTable?.count)!
    }
    
    public func pubAt(_ index:Int) -> PubModelRealm? {
        return listOfPubTable?[index]
    }
    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }

    
   private func bindRx() {
    
    
    // Observa los cambios en base de datos
    
     Observable<Results<PubModelRealm>>.changeset(from: listOfPubTable!)
     .subscribe(onNext: { results, changes in
     if let changes = changes {
     // it's an update
        if (!self.loadingDataServer){
           self.refreshListOfPub.value = true
        }
     
     }
     }).addDisposableTo(self.disposeBag)
     
    
    // Observer query change
    
    query.asObservable().skip(1).subscribe(
        onNext:{value in
            self.start = 0
            
            if (self.firstSuscriptionSearchBar){
                self.firstSuscriptionSearchBar = false
               
            } else {
                self.listOfPub(addRegister: false)
                self.filterAction = true
            }
            
            
    }
    
    ).addDisposableTo(disposeBag)
    
    
    }
    
    private func saveDataInPubModelRealm(dataPub:[JSONDictionary]) {
    
        self.loadingDataServer = true  // for not emit event when load data massive        
        for each in dataPub {
            let dataPub = PubModelRealm()
            dataPub.name = each["name"] as! String
            dataPub.id = each["_id"] as! String
            dataPub.ownerid = each["owner_id"] as! String
            
            if let events = each["events"] as? NSArray {
                
                for each in events {
                    dataPub.events.append(PubModelEventRealm(event: each as! String))
                }
                
            }
            if let photos = each["photos"] as? NSArray {
                for each in photos {
                    dataPub.photos.append(PubModelPhotoRealm(photo: each as! String))
                }
            }
            
            if let coordinates = each["coordinates"] as? NSArray {
                dataPub.coordinates.append(PubModelGpsRealm(gps: coordinates as! Array<Double>))
            }
            
            
            try! realm.write {
                realm.add(dataPub)
            }
        }
        // when loading is finish emit event for update
        self.loadingDataServer = false
        self.refreshListOfPub.value = true
        
        
        
    }
    
    private func deleteAllRegisterInPubModelRealm(){
        
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    
    
}
