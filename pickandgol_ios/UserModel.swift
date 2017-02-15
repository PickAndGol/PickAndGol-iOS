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

    func getUserDetail() -> Observable<UserModelStruct> {

        return apiRepository.userDetail(userId: "12")
    }
}
