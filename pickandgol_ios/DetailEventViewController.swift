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

class DetailEventViewController: UIViewController {

    
    @IBOutlet weak var photoEvent: UIImageView!
    var detailEvent:DetailEventViewModel!
    
    
    @IBOutlet weak var descriptionEvent: UILabel!
    @IBOutlet weak var titleEvent: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleEvent.text = detailEvent.getTitle()
        descriptionEvent.text = detailEvent.getDescription()
        detailEvent.getPhoto().bindTo(photoEvent.rx.image).addDisposableTo(disposeBag)
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDetailEvent(event:DetailEventViewModel){
        self.detailEvent = event
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
