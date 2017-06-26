
//
//  TimelineViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class TimelineViewModel {
    
    private let client: Client
    private let realm = try! Realm()
    var loadingDataServer = false
    let listOfEventTable:Results<PubTimelineModel>?
    private var start = 0
    private let limit = 20
    var filterAction = false
    let refreshListOfEvent = Variable<Bool>(false)
    private var firstSuscriptionSearchBar = true
    var oldValueSearch = ""
   
   
    
    
    init(client: Client = Client()) {
        self.client = client
        
        listOfEventTable = realm.objects(PubTimelineModel.self)
        bindRx()
        listOfEvent()
    
    }

    let disposeBag = DisposeBag()
    var query = Variable<(String)>("")
    var refreshTableEvent = PublishSubject<Bool>()
    
    
 

    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    

    
    private func bindRx() {
        
        
        // Observa los cambios en base de datos
        
        Observable<Results<PubTimelineModel>>.changeset(from: listOfEventTable!)
            .subscribe(onNext: { results, changes in
                if let changes = changes {
                    // it's an update
                    if (!self.loadingDataServer){
                        self.refreshListOfEvent.value = true
                    }
                    
                }
            }).addDisposableTo(self.disposeBag)
        
        
        // Observer query change
        
        query.asObservable().skip(1).subscribe(
            onNext:{value in
            
                
                if (self.oldValueSearch != value){
                    self.oldValueSearch = value
                    self.start = 0
                    
                }
                
                if (self.firstSuscriptionSearchBar){
                    self.firstSuscriptionSearchBar = false
                    
                } else {
                    self.listOfEvent(addRegister: false)
                    self.filterAction = true
                }
                
                
        }
            
            ).addDisposableTo(disposeBag)
        
        
    }
    
 
    private func saveDataInTimeLineModel(dataEvent:[JSONDictionary]) {
        
        self.loadingDataServer = true  // for not emit event when load data massive
        for each in dataEvent {
            //let dataPubEvent = PubTimelineModel(name: each["name"] as! String, descriptionEvent: each["description"] as! String, photoUrl: each["photo_url"] as! String)
            
            let categoryEvent = each["category"] as! NSArray
            
            let dataPubEvent = PubTimelineModel(idEvent: each["_id"] as! String, name: each["name"] as! String, date: each["date"] as! String, category: categoryEvent[0] as! String, photoUrl: each["photo_url"] as! String, description: each["description"] as! String, creator: each["creator"] as! String)
            
            if let pubs = each["pubs"] as? NSArray {
                
                for each in pubs {
                    dataPubEvent.pubs.append(pubsOfEvent(idPub: each as! String))
                }
                
            }
            
            
            
            
            try! realm.write {
                realm.add(dataPubEvent)
            }
        }
        // when loading is finish emit event for update
        self.loadingDataServer = false
        self.refreshListOfEvent.value = true
        
    
        
    }
    
    private func deleteAllRegisterInPubModelRealm(){
        
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    public func numOfEvent() -> Int {
        return (listOfEventTable?.count)!
    }
    
    public func EventAt(_ index:Int) -> PubTimelineModel? {
        return listOfEventTable?[index]
    }
    
    public func pubTimelineModelToJsondictionary(data:PubTimelineModel) -> JSONDictionary {
        
        var dictionary:JSONDictionary = [:]
        dictionary["name"] = data.name as AnyObject
        dictionary["photo_url"] = data.photourl as AnyObject
        dictionary["pubs"] = Array(data.pubs) as AnyObject
        dictionary["date"] = data.date as AnyObject
        dictionary["category"] = data.category as AnyObject
        dictionary["description"] = data.descriptionEvent as AnyObject
        
        return dictionary
        
    }
    public func listOfEvent(addRegister:Bool = true) {
        
        var params = ("start=\(self.start)&limit=\(limit)")
        
        if(query.value != ""){
            params+="&text="+query.value
        }
        
        
        self.client.listEvent(params:params).subscribe(onNext: { (element) in
            
            
            let returnElement = (element.count)
            
            if(!addRegister){
                self.deleteAllRegisterInPubModelRealm()
            }else{
                //self.start += returnElement
                
            }
            self.start += returnElement
            if ( returnElement > 0 ){
                
                self.saveDataInTimeLineModel(dataEvent: element)
            }
            
            
        }).addDisposableTo(self.disposeBag)
        
        
    }

   
    
    
}
