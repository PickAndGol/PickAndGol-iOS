//
//  RegisterViewController.swift
//  pickandgol_ios
//
//  Created by Edu González on 19/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    var registerViewModel =     RegisterViewModel()

    @IBOutlet weak var usarNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        usarNameTextField.tag = 1;
        userEmailTextField.tag = 2;
        userPasswordTextField.tag = 3;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: .UITextFieldTextDidChange,
            object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let name = usarNameTextField.text,
            let email = userEmailTextField.text,
            let password = userPasswordTextField.text else {
                return
        }
        if formIsValid() {
            registerViewModel.userRegister(name: name,
                                           email: email,
                                           password: password)
        }

    }
    
    func textFieldDidChange(_ notification: NSNotification) {

        guard let textField = notification.object as? UITextField,
            let text = textField.text else {
                return
        }
        textField.layer.borderWidth = 1.0
        switch textField.tag {
        case 1:
            usarNameTextField.layer.borderColor = registerViewModel.validateUserName(username: text) ? UIColor.green.cgColor : UIColor.red.cgColor
        case 2:
            userEmailTextField.layer.borderColor =  registerViewModel.validateUserEmail(email: text) ? UIColor.green.cgColor : UIColor.red.cgColor
        case 3:
            userPasswordTextField.layer.borderColor = registerViewModel.validatePassword(password: text) ? UIColor.green.cgColor : UIColor.red.cgColor
        default:
            return
        }
    }

    func formIsValid() -> Bool {
        return registerViewModel.validateUserName(username: usarNameTextField.text!)
        && registerViewModel.validateUserEmail(email: userEmailTextField.text!)
        && registerViewModel.validatePassword(password: userPasswordTextField.text!)
    }

    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}
