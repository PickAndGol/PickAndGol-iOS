//
//  httpMethods.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 9/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
