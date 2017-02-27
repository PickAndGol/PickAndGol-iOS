//
//  UITextField+isValid.swift
//  pickandgol_ios
//
//  Created by Edu González on 27/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit

extension UITextField {

    func isValid(valid: Bool) {

        self.layer.borderWidth = 1

        self.layer.borderColor = valid ? UIColor.green.cgColor : UIColor.red.cgColor
    }
}
