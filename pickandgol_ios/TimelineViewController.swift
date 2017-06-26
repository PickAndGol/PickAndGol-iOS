//
//  TimelineViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class TimelineViewController: UIViewController, UICollectionViewDelegate {
 
    @IBOutlet weak var timelineEventDetail: UICollectionView!{
        didSet{
            //timelineEventDetail.backgroundColor = UIColor.brown
        }
        
    }
    
   
    @IBOutlet weak var searchbar: UISearchBar!
    
    fileprivate let viewModel = TimelineViewModel()
    fileprivate let disposeBag = DisposeBag()
    fileprivate var filterSearch = false
  
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        bindRx()
        searchBar()
        
        timelineEventDetail.delegate = self
        timelineEventDetail.dataSource = self
        self.hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchBar() {
        searchbar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value
                self.viewModel.query.value = query
            })
            .addDisposableTo(disposeBag)
    }
    
    
    // en vez de hacer un segue instanciar por codigo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        guard let nextVC: DetailEventViewController = segue.destination as? DetailEventViewController else {
            return
        }
        let selectedItem = self.timelineEventDetail.indexPathsForSelectedItems
        let eventSelected = self.viewModel.EventAt( (selectedItem?[0].row)!)
        let viewModel = DetailEventViewModel(eventDetail: self.viewModel.pubTimelineModelToJsondictionary(data: eventSelected!))
        nextVC.setDetailEvent(event: viewModel)
        
    }
    
    func bindRx(){
        viewModel.refreshListOfEvent.asObservable().subscribe(
            
            onNext:{ value in
                if(value){
                    
                    self.timelineEventDetail.reloadData()
                }
        }
            
            ).addDisposableTo(self.disposeBag)
    }
    
    
    
}


extension TimelineViewController:UICollectionViewDataSource {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfEvent()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let event = viewModel.EventAt(indexPath.row)
        
        guard let cell = self.timelineEventDetail.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TimelineCollectionViewCell else {
            fatalError("missing cell")
        }
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.eventDescription.lineBreakMode = .byWordWrapping
        
        cell.eventTitle.text = event?["name"]! as? String
        cell.eventDescription.text = event?["descriptionEvent"]! as? String
        cell.imageEvent.image = UIImage(imageLiteralResourceName:"default_placeholder.png")
        cell.sizeToFit()
        
        
        if (event?["photourl"] as! String != ""){
            self.viewModel.downLoadImage(image: event?["photourl"] as! String).bindTo(cell.imageEvent.rx.image).addDisposableTo(self.disposeBag)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath.row == collectionView.numberOfItems-1){
            if (!viewModel.filterAction){
                
                viewModel.listOfEvent(addRegister: true)
            }
            filterSearch = !filterSearch
            
        }
        viewModel.filterAction = false
 
        
    }

   


}


