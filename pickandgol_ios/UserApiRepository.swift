
import Foundation
import RxSwift
import Alamofire

public enum ApiClientError: Error {
    case couldNotDecodeJSON
    case failedParsingData(JSONDictionary)
    case badStatus(String)
}

class UserApiRepository {

    func userRegister(name: String, email: String, password: String) -> Observable<UserModelStruct> {

        //let url: URL = URL(string: "register", relativeTo: ApiPaths.user.url.absoluteURL)!
        let url = URL(string: "http://pickandgol.com/api/v1/users/register")
        
        return Observable.create { observer in
            let params: Parameters = [
                "name":name,
                "email": email,
                "password": password]

            let request = Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON(completionHandler: { response in
                    guard response.result.isSuccess else {
                        observer.onError(response.result.error!)
                        observer.onCompleted()
                        return
                    }
                    guard let value = response.result.value as? JSONDictionary,
                        let result = value["result"] as? String,
                        let data = value["data"] as? JSONDictionary else{
                            observer.onError(ApiClientError.couldNotDecodeJSON)
                            observer.onCompleted()
                            return
                    }
                    if result == "ERROR" {

                        // Como gestionar los errores
                        guard let errorCode: Int = data["code"] as? Int else {
                            return
                        }
                        var errorDescription = String()
                        if errorCode == 409 {
                            errorDescription = "El usuario ya existe"
                        } else {
                            errorDescription = "El servidor no responde"
                        }

                        observer.onError(ApiClientError.badStatus(errorDescription))
                        observer.onCompleted()
                    }
                    if result == "OK" {
                        do {
                            let user = try UserModelStruct(dictionary: data)
                            observer.onNext(user)
                            observer.onCompleted()
                        } catch {
                            observer.onError(ApiClientError.failedParsingData(data))
                            observer.onCompleted()
                        }
                    }
                })

            return Disposables.create(with: {
                request.cancel()
            })
        }
    }

    func userLogin(email: String, password: String) -> Observable<UserModelStruct> {

        return Observable.create { observer in

            let url: URL = URL(string: "login", relativeTo: ApiPaths.user.url.absoluteURL)!
            let params: Parameters = [
            "email": email,
            "password": password]

            let request = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON(completionHandler: { response in

                    guard response.result.isSuccess else {
                        observer.onError(response.result.error!)
                        observer.onCompleted()
                        return
                    }
                    guard let value = response.result.value as? JSONDictionary,
                        let result = value["result"] as? String,
                        let data = value["data"] as? JSONDictionary else{
                            observer.onError(ApiClientError.couldNotDecodeJSON)
                            observer.onCompleted()
                            return
                    }
                    if result == "ERROR" {
                        observer.onError(ApiClientError.badStatus(""))
                        observer.onCompleted()
                    }
                    if result == "OK" {

                        do {
                            let user = try UserModelStruct(dictionary: data)
                            observer.onNext(user)
                            observer.onCompleted()
                        } catch {
                            observer.onError(ApiClientError.failedParsingData(data))
                            observer.onCompleted()
                        }
                    }
                })

            return Disposables.create(with: {
                request.cancel()
            })
        }
    }

    func userDetail(userId: Int) -> Observable<UserModelStruct> {

        return Observable.create { observer in

            let url: URL = URL(string: userId.description, relativeTo: ApiPaths.user.url)!

            // Crear request con parametros
            let request = Alamofire.request(url)
                .responseJSON(completionHandler: { response in

                    guard response.result.isSuccess else {
                        observer.onError(response.result.error!)
                        observer.onCompleted()
                        return
                    }
                    guard let value = response.result.value as? JSONDictionary,
                        let result = value["result"] as? String,
                        let data = value["data"] as? JSONDictionary else{
                            observer.onError(ApiClientError.couldNotDecodeJSON)
                            observer.onCompleted()
                            return
                    }
                    if result == "ERROR" {
                        observer.onError(ApiClientError.badStatus(""))
                        observer.onCompleted()
                    }
                    if result == "OK" {

                        do {
                            let user = try UserModelStruct(dictionary: data)
                            observer.onNext(user)
                            observer.onCompleted()
                        } catch {
                            observer.onError(ApiClientError.failedParsingData(data))
                            observer.onCompleted()
                        }
                    }
                })
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}
