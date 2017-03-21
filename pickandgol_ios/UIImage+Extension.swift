//
//  UIImage+Extension.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 16/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundImage(borderColor:UIColor = UIColor.black){
       
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
    }
    
    
}
