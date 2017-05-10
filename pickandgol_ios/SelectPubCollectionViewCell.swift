//
//  SelectPubCollectionViewCell.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 24/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit

class SelectPubCollectionViewCell: UICollectionViewCell {
    
  
    @IBOutlet weak var pubName: UILabel!
    
    @IBOutlet weak var pubPhoto: UIImageView!
    
    
    override func prepareForReuse() {
        pubPhoto.image = nil
    }
    
}
