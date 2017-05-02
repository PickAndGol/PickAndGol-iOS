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

class SelectPubViewModel {
    
    private let client: Client
    private let realm = try! Realm()
    
    let listOfPubTable = PublishSubject<[JSONDictionary]>()
    var itemsPub = [JSONDictionary]()
    let refreshListOfPub = Variable<Bool>(false)
    
    init(client: Client = Client()) {
        self.client = client
        bindRx()
        deleteAllRegisterInPubModelRealm()
        
    }
    
    var events: Observable<[JSONDictionary]> {
        return listOfPubTable.asObservable()
    }
    
    
    let disposeBag = DisposeBag()
    
    /*public func listOfPub()->Observable<[JSONDictionary]>{
        
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            
            
            self.client.ListAllPub().subscribe(onNext: { (element) in
                
                observer.onNext((element.results() ?? nil)!)
                observer.onCompleted()
                
            }).addDisposableTo(self.disposeBag)
            
            
            
            return Disposables.create()
        }
        
    }*/
    
    public func listOfPub() {
        
        let params = "start=0&limit=60"
        self.client.ListAllPub(params:params).subscribe(onNext: { (element) in
            self.saveDataInPubModelRealm(dataPub: element.results()!)
            //itemsPub.append(element.results())
            self.listOfPubTable.onNext((element.results() ?? nil)!)
         
            
        }).addDisposableTo(self.disposeBag)
        
        
    }
    
    
    
    public func bindRx() {
    
        
        // Refresh data if a new comerce is save en NewPub
        
        refreshListOfPub.asObservable()
        .subscribe(
            onNext:{ value in
                
                if(value){
                    
                   self.listOfPub()
                    
                }
            
        }
        ).addDisposableTo(self.disposeBag)
        
        
        // Asigndata of comerce
        
        listOfPub()
        
        
    }
    
    private func saveDataInPubModelRealm(dataPub:[JSONDictionary]) {
    
        for each in dataPub {
            let dataPub = PubModelRealm()
            dataPub.name = each["name"] as! String
        
            try! realm.write {
                realm.add(dataPub)
            }
        }
        
    }
    
    private func deleteAllRegisterInPubModelRealm(){
        
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    
    
}
