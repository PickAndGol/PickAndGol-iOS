//
//  S2ConfigSingleton.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 12/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import AWSS3

class S3ConfigSingleton {
    
    let bucket:String
    let credentialProvider:AWSCredentialsProvider
    let configuration:AWSServiceConfiguration
    let urlBucket:URL
    
    static let sharedInstance = S3ConfigSingleton()
    
    
    private init(){
        
        credentialProvider = AWSCognitoCredentialsProvider(regionType: .EUWest1, identityPoolId: "eu-west-1:45da37a2-d874-4a37-b94e-752a9120c937")
        configuration = AWSServiceConfiguration(region:.EUWest1, credentialsProvider:credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        bucket = "pickandgol"
        urlBucket = URL(string: "https://s3-eu-west-1.amazonaws.com/pickandgol/")!
        
    }
    
}
