//
//  MapEventViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 3/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class MapPubViewController: UIViewController {

    let viewModel = MapPubViewModel()
    let disposeBag = DisposeBag()
    let regionRadius: CLLocationDistance = 5000
    
    @IBOutlet weak var distanceEvent: UILabel!
    @IBOutlet weak var pubMap: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var distanceMapSlider: UISlider!
    
    
    @IBAction func distanceMap(_ sender: Any) {
        distanceEvent.text = String(Int(distanceMapSlider.value))
        synMap()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        centerMapOnLocation(location: CurrentPositionUser.sharedInstance.getLocation())
        self.hideKeyboardWhenTappedAround() 

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func synMap(){
        deleteAnnotation()
        self.viewModel.listCategory(radius:String(Int(distanceMapSlider.value)), textFilter:searchBar.text!).subscribe(
            
            onNext:{result in
                self.pubMap.addAnnotations(result)
        },
            onError:{error in
                print(error)
        },
            onCompleted: nil,
            onDisposed: nil).addDisposableTo(self.disposeBag)
        

    }
    
    func deleteAnnotation(){
        let annotationsToRemove = pubMap.annotations.filter { $0 !== pubMap.userLocation }
        pubMap.removeAnnotations( annotationsToRemove )
    }
    
    
        
     func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                    regionRadius * 10.0, regionRadius * 10.0)
        pubMap.setRegion(coordinateRegion, animated: true)
        }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapPubViewController : UISearchBarDelegate,UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        synMap()
        
    }
    
    
}
