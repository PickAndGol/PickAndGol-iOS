//
//  DetailEventViewController.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 27/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import MapKit

class DetailEventViewController: UIViewController {

    @IBOutlet weak var mapEvent: MKMapView!
    
    @IBOutlet weak var photoEvent: UIImageView!
    var detailEvent:DetailEventViewModel!
    
    
    @IBOutlet weak var descriptionEvent: UILabel!
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var pubEvent: UILabel!
    
    @IBOutlet weak var addressEvent: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleEvent.text = detailEvent.getDate()
        self.title = detailEvent.getTitle()
        descriptionEvent.text = detailEvent.getDescription()
        detailEvent.getPhoto().bindTo(photoEvent.rx.image).addDisposableTo(disposeBag)
        detailEvent.getLocation().subscribe(
            onNext:{ result in
                self.pubEvent.text = result.model.name
                self.detailEvent.getAddressFromLatLon(pdblLatitude: result.model.location.coordinate.latitude, withLongitude: result.model.location.coordinate.longitude)
                self.centerMapOnLocation(location: result.model.location)
                let coordinatePub = CLLocationCoordinate2D(latitude: result.model.location.coordinate.latitude, longitude: result.model.location.coordinate.longitude)
                
                self.detailEvent.addressEvent.subscribe(
                
                    onNext:{value in
                
                        self.addressEvent.text = value.splitted(by: ",")[0]
                        let annotationPub = MapsAnnotationsUtils(coordinate: coordinatePub, title:
                            result.model.name, subtitle: value)
                        self.mapEvent.addAnnotation(annotationPub)
                       
                }
                
                )
                
                
                
        },onCompleted: nil,
         onDisposed: nil).addDisposableTo(self.disposeBag)
        
        
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDetailEvent(event:DetailEventViewModel){
        self.detailEvent = event
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapEvent.setRegion(coordinateRegion, animated: true)
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
