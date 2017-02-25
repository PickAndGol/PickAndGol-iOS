//
//  UserDetailViewController.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {

        let navVC = UINavigationController()
        let loginVC: MainLoginViewController = UIStoryboard(storyboard: .login).instantiateViewController()
        navVC.viewControllers = [loginVC]
        self.present(navVC, animated: true, completion: nil)
    }
}

