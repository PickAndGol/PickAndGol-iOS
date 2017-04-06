//
//  ManagerHideKeyboard.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 5/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
