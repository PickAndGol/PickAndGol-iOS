//
//  SelectPubViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 24/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift


protocol SelectPubViewControllerDelegate{
    func pubSelectedItem(pubSelct:JSONDictionary)
}


class SelectPubViewController: UIViewController , UICollectionViewDelegate{

    private let viewModel = SelectPubViewModel()
    private let disposeBag = DisposeBag()
    var delegate:SelectPubViewControllerDelegate?
    
    var selectCell:Int?
    
    @IBOutlet weak var listOfPubDetail: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTable()
        observerTap()
        
        
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Do any additional setup after loading the view.
    
    
    func loadTable(){
        
        let realm = try! Realm()
        let dataPub = realm.objects(PubModelRealm.self)
        Observable.from( dataPub)
          .bindTo(listOfPubDetail.rx.items) { collectionView, row, event in
        
        
        //viewModel.listOfPubTable.bindTo(listOfPubDetail.rx.items) { collectionView, row, event in
            
            let indexPath = IndexPath(item: row, section: 0)
            
            guard let cell = self.listOfPubDetail.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SelectPubCollectionViewCell else {
                fatalError("missing cell")
            }
            
            self.selectCell = row
            cell.pubName.text = event["name"] as! String?
            return cell
            }
            .addDisposableTo(disposeBag)
    }
    
    
    func observerTap(){
        listOfPubDetail.rx.modelSelected(JSONDictionary.self).subscribe(onNext: { value in
            self.delegate?.pubSelectedItem(pubSelct: value)
            self.navigationController?.popViewController(animated: true)
            
        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func unwindWithSelectedGame(segue:UIStoryboardSegue) {
        
        if segue.source is  NewItemViewController{
            
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.source is  NewItemViewController{
            
        }
        
    }

    
    
    
    
    
}









