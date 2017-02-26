//
//  MainLoginViewController.swift
//  pickandgol_ios
//
//  Created by Edu González on 19/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit

class MainLoginViewController: UIViewController {

    @IBAction func cancelButton(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }

    // en vez de hacer un segue instanciar por codigo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSegue" {

            guard let nextVC: RegisterViewController = segue.destination as? RegisterViewController else {
                return
            }
            let userModel = UserModel()
            let viewModel = RegisterViewModel(model: userModel)
            nextVC.setViewModel(viewModel: viewModel)

        }
    }
}
