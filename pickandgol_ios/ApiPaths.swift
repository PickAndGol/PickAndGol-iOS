//
//  ApiPaths.swift
//  pickandgol_ios
//
//  Created by Edu González on 15/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation

enum ApiPaths {

    case user
    case event
    case pub

    private var baseURL: URL {
        return URL(string:"http://www.pickandgol.com/api/v1/")!
    }
    private var path: String {
        switch self {
        case .user:
            return "users/"
        case .event:
            return "events/"
        case .pub:
            return "pubs/"
        }
    }
    var url: URL {
        let path = self.path
        let baseURL = self.baseURL
        return URL(string: path, relativeTo: baseURL)!
    }

}
