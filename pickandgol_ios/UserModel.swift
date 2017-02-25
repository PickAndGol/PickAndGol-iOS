//
//  UserModel.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift

struct UserModel {

    private let apiRepository = UserApiRepository()
    private let dataBaseRepository = UserDataBaseRepository()

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
