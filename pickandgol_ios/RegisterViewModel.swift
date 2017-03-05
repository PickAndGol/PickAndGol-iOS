
import Foundation
import RxSwift

class RegisterViewModel {

    let userModel: UserModel
//    private(set) lazy var isRegister: Observable<UserModelStruct> = self.userModel
//        .userRegister(name: self.userName.value, email: self.userEmail.value, password: self.userPassword.value)

    var userName = Variable("")
    var userEmail = Variable("")
    var userPassword = Variable("")

    var userNameIsValid: Observable<Bool> {
        return userName.asObservable().map { username in
            return !username.isEmpty
        }
    }
    var userEmailIsValid: Observable<Bool> {
        return userEmail.asObservable().map { useremail in
            return !useremail.isEmpty
        }
    }
    var userPasswordIsValid: Observable<Bool> {
        return userPassword.asObservable().map {
            !$0.isEmpty
        }
    }
    var formIsValid: Observable<Bool> {
        return Observable.combineLatest(userNameIsValid, userEmailIsValid, userPasswordIsValid) {$0 && $1 && $2 }
    }


    init(model: UserModel) {
        userModel = model
    }

    func registerUser() -> Observable<UserModelStruct> {
        return self.userModel
            .userRegister(name: self.userName.value, email: self.userEmail.value, password: self.userPassword.value)
    }

}
