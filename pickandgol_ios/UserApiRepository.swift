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

public enum ApiError: Error {
    case couldNotDecodeJSON
    case badStatus(JSONDictionary)
    case failedParsingData
}

class UserApiRepository {

    func userRegister(name: String, email: String, password: String) -> Observable<UserModelStruct> {

        let url: URL = URL(string: "register", relativeTo: ApiPaths.user.url.absoluteURL)!

        return Observable.create { observer in

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
                            observer.onError(ApiError.couldNotDecodeJSON)
                            observer.onCompleted()
                            return
                    }
                    if result == "error" {
                        observer.onError(ApiError.badStatus(data))
                        observer.onCompleted()
                    }
                    if result == "OK" {

                        do {
//                            let user = try UserModelStruct(dictionary: data)
                            // TODO: - ¿porque no extrae el optional?
//                            observer.onNext(user)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
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

            // Crear request con parametros
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
                            observer.onError(ApiError.couldNotDecodeJSON)
                            observer.onCompleted()
                            return
                    }
                    if result == "error" {
                        observer.onError(ApiError.badStatus(data))
                        observer.onCompleted()
                    }
                    if result == "OK" {

                        do {
//                            let user = try UserModelStruct(dictionary: data)
                            // TODO: - ¿porque no extrae el optional?
                            // TODO: - ¿que hacemos con el token, donde lo guardamos?
                            // observer.onNext(user)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
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
                            observer.onError(ApiError.couldNotDecodeJSON)
                            observer.onCompleted()
                            return
                    }
                    if result == "error" {
                        observer.onError(ApiError.badStatus(data))
                        observer.onCompleted()
                    }
                    if result == "OK" {

                        do {
//                            let user = try UserModelStruct(dictionary: data)
                            // TODO: - ¿porque no extrae el optional?
                            // observer.onNext(user)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
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
