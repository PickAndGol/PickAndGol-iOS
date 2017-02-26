

import Foundation
import RxSwift

class RegisterViewModel {

    let userModel: UserModel
    private(set) lazy var isRegister: Observable<UserModelStruct> = self.userModel
        .userRegister(name: self.userName, email: self.userEmail, password: self.userPassword)

    var userName = String() {
        didSet {
            validateUserName(username: userName)
        }
    }
    var userEmail = String() {
        didSet {
            validateUserEmail(email: userEmail)
        }
    }
    var userPassword = String() {
        didSet {
            validatePassword(password: userPassword)
        }
    }

    var userNameValid: Bool = false
    var userEmailValid: Bool = false
    var userPasswordValid: Bool = false

    fileprivate let disposeBag = DisposeBag()

    init(model: UserModel) {
        userModel = model
    }

    func registerUser() -> Observable<UserModelStruct> {
// Como devolver nada si no es valido el formulario
        //        if formIsValid() {
            return self.isRegister
//        }
    }

    fileprivate func validateUserName(username: String?) {
        guard let username = username, !username.isEmpty else {
            return userNameValid = false
        }
        userNameValid = true
    }
    fileprivate func validateUserEmail(email: String?) {
        guard let email = email, !email.isEmpty else {
            return userEmailValid = false
        }
        userEmailValid = true
    }
    fileprivate func validatePassword(password: String?) {
        guard let password = password, !password.isEmpty else {
            return userPasswordValid = false
        }
        userPasswordValid = true
    }
    fileprivate func formIsValid() -> Bool {
        return userNameValid && userEmailValid && userPasswordValid
    }
}
