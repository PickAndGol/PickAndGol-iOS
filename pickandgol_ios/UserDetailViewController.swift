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

    @IBAction func registerButtonTapped(_ sender: Any) {

        openMainLogin()
    }
    
    override func viewDidLoad() {

        // Si no estamos logados
        openMainLogin()
    }

    func openMainLogin() {
        let navVC = UINavigationController()
        let loginVC: MainLoginViewController = UIStoryboard(storyboard: .login).instantiateViewController()
        navVC.viewControllers = [loginVC]
        self.present(navVC, animated: true, completion: nil)
    }

}

