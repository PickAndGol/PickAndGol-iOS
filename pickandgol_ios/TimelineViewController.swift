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



class TimelineViewController: UIViewController, UISearchBarDelegate,UISearchResultsUpdating,UICollectionViewDelegate {

    
    @IBOutlet weak var timelineEventDetail: UICollectionView!{
        didSet{
            //timelineEventDetail.backgroundColor = UIColor.brown
        }
        
    }
    
   
    @IBOutlet weak var searchbar: UISearchBar!
    
    private let viewModel = TimelineViewModel()
    private let disposeBag = DisposeBag()
  
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        bindRx()
        timelineEventDetail.delegate = self
    
       
        
       
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        
        if (indexPath.row == collectionView.numberOfItems-1){
            print(collectionView.numberOfItems)
            viewModel.refreshTable()
           
           
        }
        
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func bindRx(){
        viewModel.eventsPubs.bindTo(timelineEventDetail.rx.items) { collectionView, row, event in
            
            let indexPath = IndexPath(item: row, section: 0)
            
            guard let cell = self.timelineEventDetail.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TimelineCollectionViewCell else {
                fatalError("missing cell")
            }
            
            let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
            cell.layer.borderColor = bcolor.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 3
            
            cell.eventDescription.lineBreakMode = .byWordWrapping
            
            cell.eventTitle.text = event["name"]! as? String
            cell.eventDescription.text = event["description"]! as? String
            cell.imageEvent.image = UIImage(imageLiteralResourceName:"default_placeholder.png")
            
            if (event["photo_url"] as! String != ""){
                self.viewModel.downLoadImage(image: event["photo_url"] as! String).bindTo(cell.imageEvent.rx.image).addDisposableTo(self.disposeBag)
            }
            
                        
            return cell
            }
            .addDisposableTo(disposeBag)
    }
    
    
    
    
    // en vez de hacer un segue instanciar por codigo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailEventSegue" {
            
            
            timelineEventDetail.rx.modelSelected(JSONDictionary.self).subscribe(onNext: { value in
                
                guard let nextVC: DetailEventViewController = segue.destination as? DetailEventViewController else {
                    return
                }
                
                let viewModel = DetailEventViewModel(eventDetail: value)
                nextVC.setDetailEvent(event: viewModel)
                
                
            }).addDisposableTo(disposeBag)
            
           
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.query.value = searchText
        
    }
    
    
    
}


