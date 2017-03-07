//
//  TimelineCollectionViewCell.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 4/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageEvent: UIImageView!
   
    @IBOutlet weak var eventTitle: UILabel!
    
    public func putTitle(title:String){
        
        self.eventTitle.text = "HOLA"
    }
    
    
}
