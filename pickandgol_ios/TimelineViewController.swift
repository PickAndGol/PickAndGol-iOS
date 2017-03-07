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



class TimelineViewController: UIViewController {

    
    @IBOutlet weak var timelineEventDetail: UICollectionView!{
        didSet{
            timelineEventDetail.backgroundColor = UIColor.brown
        }
        
    }
    
   
    
    private let viewModel = TimelineViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        viewModel.listOfEvent().bindTo(timelineEventDetail.rx.items) { collectionView, row, event in
            
            let indexPath = IndexPath(item: row, section: 0)
            //let cell: TimelineCollectionViewCell = timelineEventDetail.dequeueReusableCell(withReuseIdentifier: "cell", for: <#T##IndexPath#>)
            guard let cell = self.timelineEventDetail.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TimelineCollectionViewCell else {
                fatalError("missing cell")
            }
            
            cell.eventTitle.text = event["name"]! as! String
            self.viewModel.downLoadImage(image: event["name"] as! String).bindTo(cell.imageEvent.rx.image)
            
           
            
            return cell
            }
            .addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
