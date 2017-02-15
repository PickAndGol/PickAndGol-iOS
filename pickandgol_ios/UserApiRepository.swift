//
//  UserApiRepository.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class UserApiRepository {

    func userLogin(email: String, password: String) -> Observable<String> {

        return Observable.create { observer in

            let url: URL = URL(string: "login", relativeTo: ApiPaths.user.url.absoluteURL)!
            let params: Parameters = [
            "email": email,
            "password": password
            ]

            // Crear request con parametros
            let request = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON(completionHandler: { response in

                    // DEVUELVE EL TOKEN!!!!

                    guard response.result.isSuccess else {
                        observer.onError(response.result.error!)
                        return observer.onCompleted()
                    }

                    guard let json = response.result.value as? JSONDictionary else {
                        observer.onError(JSONDecodingError.errorDecodingJSON)
                        return observer.onCompleted()
                    }
                    // parseamos el objeto response.result.value en un token

                    let token: String = "";

                    observer.onNext(token)
                    observer.onCompleted()
                })

            return Disposables.create(with: {
                request.cancel()
            })
        }
    }

    func userDetail(userId: String) -> Observable<UserModelStruct> {

        return Observable.create { observer in

            let url: URL = URL(string: userId, relativeTo: ApiPaths.user.url)!

            // Crear request con parametros
            let request = Alamofire.request(url)
                .responseJSON(completionHandler: { response in

                    guard response.result.isSuccess else {
                        observer.onError(response.result.error!)
                        return observer.onCompleted()
                    }

                    guard let json = response.result.value as? JSONDictionary,
                    let userDict = json["data"] as? JSONDictionary else {
                        observer.onError(JSONDecodingError.errorDecodingJSON)
                        return observer.onCompleted()
                    }
                    // parseamos el objeto userDict en un UserModel

                    let user: UserModelStruct = UserModelStruct()

                    observer.onNext(user)
                    observer.onCompleted()
                })
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}
