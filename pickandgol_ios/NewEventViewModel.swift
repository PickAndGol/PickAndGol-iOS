//
//  NewEventViewModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 12/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwifterSwift
import RxSwift
import SwiftKeychainWrapper

enum newItemError:Error {
    case Error
    case PubNotFound
}


class NewEventViewModel{


    let client = Client()
    let disposeBag = DisposeBag()
       
    
    
    func saveEvent(dictionary dic:JSONDictionary) -> Observable<Bool>{
        
        return Observable<Bool>.create({ (observer) -> Disposable in
        
         self.client.saveEvent(dic: dic).subscribe(
            onNext: { (element) in
                if (element.status == "ERROR"){
                   observer.onNext(false)
                }else {
                    observer.onNext(true)
                }
                    observer.onCompleted()
                    },
            onError:{ (error) in
                    observer.onError(error)
          }
            ).addDisposableTo(self.disposeBag)
         
            return Disposables.create()
        })
        
        
    }
    
  
    
    public func listCategory()->Observable<[JSONDictionary]>{
        
        return Observable<[JSONDictionary]>.create { (observer) -> Disposable in
            self.client.listCategory().subscribe(onNext: { (element) in
                observer.onNext(element)
                observer.onCompleted()
            }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
    }
    
    public func changeSelect(cell:UICollectionViewCell, type:cellStatus) {
        let cell = cell as! categoryPubCollectionViewCell
        
        switch type {
        case .select:
            cell.contentView.backgroundColor = UIColor.blue
            cell.nameCategory.textColor = UIColor.white
        case .deselect:
            cell.contentView.backgroundColor = UIColor.white
            cell.nameCategory.textColor = UIColor.black
        }
    }
    
    public func dateToMogo(date:String) -> String{
        let strTime = date.splitted(by: " ")
        let dateIso = strTime[0].splitted(by: "-")
        return  dateIso[2]+"-"+dateIso[1]+"-"+dateIso[0]+"T"+strTime[1]+":00.000Z"
    }
    
   
    
    func login(controller: UIViewController){
        let session = userSessionManager.sharedInstance
        if (!session.logged){
            guard let email = KeychainWrapper.standard.string(forKey: "pickangol-email"), let pass = KeychainWrapper.standard.string(forKey: "pickangol-pass") else {
                openMainLogin(controller: controller)
                return
            }
            
            client.login(email: email, password: pass).subscribe( onNext: { (element) in
                let session = userSessionManager.sharedInstance
                session.initWithLogin(dict: element.result() as! JSONDictionary)
            }).addDisposableTo(self.disposeBag)
            
          
            
        }
    }
    
    func openMainLogin(controller: UIViewController) {
        
        let navVC = UINavigationController()
        let loginVC: MainLoginViewController = UIStoryboard(storyboard: .login).instantiateViewController()
        navVC.viewControllers = [loginVC]
        controller.present(navVC, animated: true, completion: nil)
        
    }

    

}

