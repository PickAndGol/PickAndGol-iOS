
import Foundation
import RxSwift

struct UserModel {

    private let apiRepository = UserApiRepository()
    private let dataBaseRepository = UserDataBaseRepository()

    // Concatenar el guardado de datos en el databaseREpo en la respuesta
    // Concatenar la busqueda de datos en el databaseREpo
    func userRegister(name: String, email: String, password: String) -> Observable<UserModelStruct> {

        return apiRepository.userRegister(name: name, email: email, password: password)
    }

    func userLogin(email: String, password: String) -> Observable<UserModelStruct> {

        return apiRepository.userLogin(email: email, password: password)
    }
    
    func getUserDetail(userId: Int) -> Observable<UserModelStruct> {

        return apiRepository.userDetail(userId: userId)
    }
}
