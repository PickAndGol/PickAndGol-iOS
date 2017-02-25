//
//  RegisterViewModel.swift
//  pickandgol_ios
//
//  Created by Edu González on 19/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel {

    let userName = Variable<String>("")
    let userEmail = Variable<String>("")
    let userPassword = Variable<String>("")

    private let disposeBag = DisposeBag()

    func userRegister(name: String, email: String, password: String) {

    }

    func validateUserName(username: String?) -> Bool {
        guard let username = username, !username.isEmpty else {
            return false
        }
        return true
    }
    func validateUserEmail(email: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        return true
    }

    func validatePassword(password: String?)  -> Bool {
        guard let password = password, !password.isEmpty else {
            return false
        }
        return true
    }

}
