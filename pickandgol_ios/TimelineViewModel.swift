
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
   
    
    
    fileprivate let eventsSubject = PublishSubject<[JSONDictionary]>()
    fileprivate var eventsApi:[JSONDictionary] = []
    fileprivate var pageElement = 0
    static let limit = 10
    static let incrementElement = 10
    
    var events: Observable<[JSONDictionary]> {
        return eventsSubject.asObservable()
    }
    
    
    init(client: Client = Client()) {
        self.client = client
        
        listOfEventTable = realm.objects(PubTimelineModel.self)
        bindRx()
        listOfEvent()
        
        /*self.query.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(
                onNext:{ value in
                     self.pageElement = 0
                     self.refreshTable(refresh: true)
                    
            }
        
        ).addDisposableTo(disposeBag)
        */

        
        
    }

    let disposeBag = DisposeBag()
    var query = Variable<(String)>("")
    var refreshTableEvent = PublishSubject<Bool>()
    
    
 

    
    public func downLoadImage(image:String) -> Observable<UIImage>{
        
        
        return client.downloadImage(urlImage:URL(string:image)!)
        
    }
    
    
    /*public func refreshTable(refresh:Bool=false) {
    
        let params = "text=\(query.value)&start=\(pageElement)&limit=\(TimelineViewModel.limit)"
        print(params)
        client.listEvent(params: params).subscribe(
        
            onNext:{ value in
                if (value.count > 0) {
                    if (refresh){
                        self.eventsApi.removeAll()
                        self.eventsSubject.onNext(self.eventsApi)
                      
                    }
                    self.saveDataInTimeLineModel(dataEvent: value)
                    self.eventsApi.append(contentsOf: value)
                    self.eventsSubject.onNext(self.eventsApi)
                    self.pageElement += value.count
                    self.refreshTableEvent.onNext(true)
                }else {
                    self.eventsSubject.onCompleted()
                }
                print("TOTAL",self.eventsApi.count)
        }
        
        ).addDisposableTo(disposeBag)
        
    
    }*/
    
    
    
// NEW FUNCTION WITH REALM
    
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
