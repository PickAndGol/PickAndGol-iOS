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
import RxRealmDataSources





class SelectPubViewController: UIViewController , UICollectionViewDelegate{

    fileprivate let viewModel = SelectPubViewModel()
    fileprivate let disposeBag = DisposeBag()
    fileprivate var filterSearch = false

    
    var selectCell:Int?
    var selectedPub = PublishSubject<String>()
   
    
   
    
    @IBOutlet weak var listOfPubDetail: UICollectionView!
    
    @IBOutlet weak var searchBarPub: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfPubDetail.delegate = self
        listOfPubDetail.dataSource = self
        bindRx()
        
       
        
        
        //loadTable()
        //observerTap()
        //syncRealm()
        searchBar()
        
        
        
      
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
    
    func searchBar() {
        searchBarPub
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value
                self.viewModel.query.value = query
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func bindRx(){
        viewModel.refreshListOfPub.asObservable().subscribe(
            
            onNext:{ value in
                if(value){
                    print("Actualiza");
                    self.listOfPubDetail.reloadData()
                }
        }
            
            ).addDisposableTo(self.disposeBag)
    }
    
    
    func loadTable(filterPub:String = ""){
        
       
        
        /*let realm = try! Realm()
        let dataPub = realm.objects(PubModelRealm.self)
        Observable.collection( from: dataPub)*/

        Observable.from(optional: self.viewModel.listOfPubTable)
          .bindTo(listOfPubDetail.rx.items) { collectionView, row, event in
        
            
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
    
    
   /* func observerTap(){
    
        listOfPubDetail.rx.modelSelected(PubModelRealm.self).subscribe(onNext: { value in
            
            
            self.navigationController?.popViewController(animated: true)
            
        }).addDisposableTo(disposeBag)
      
    }*/
    
    func syncRealm(){
        
      /*
        // create data source
        let dataSource = RxCollectionViewRealmDataSource<PubModelRealm>(cellIdentifier: "Cell", cellType: SelectPubCollectionViewCell.self) {cell, ip, lap in
            cell.pubName.text = lap.name
        }
        
        dataPub = realm.objects(PubModelRealm.self)
        let data = Observable<Results<PubModelRealm>>.changeset(from: dataPub!)
         .share()
        
        data.bindTo(listOfPubDetail.rx.realmChanges(dataSource)).addDisposableTo(disposeBag)
        */
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

extension SelectPubViewController:UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfPub()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pub = viewModel.pubAt(indexPath.row)
        let photo = pub?.photos
        
        
        
        let cell: SelectPubCollectionViewCell = self.listOfPubDetail.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SelectPubCollectionViewCell
        
        
        cell.pubName.text = pub?.name
        
        if let photoPub = photo?.first?.photo {
           
             self.viewModel.downLoadImage(image: photoPub).bindTo(cell.pubPhoto.rx.image).addDisposableTo(disposeBag)
 
            
        }
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.delegate?.pubSelectedItem(pubSelct: value.name)
        let pub = viewModel.pubAt(indexPath.row)
        self.selectedPub.onNext((pub?.name)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(collectionView.numberOfItems(inSection: 0))
        print(indexPath.row)
        if (indexPath.row == collectionView.numberOfItems-1){
            if (!viewModel.filterAction){
                
                viewModel.listOfPub(addRegister: true)
            }
            filterSearch = !filterSearch
           
        }
         viewModel.filterAction = false
        
        
    }

    
    
    
    
    
}












