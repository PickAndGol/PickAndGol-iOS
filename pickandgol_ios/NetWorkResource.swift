//
//  NetWorkResource.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 20/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import AWSS3

public enum Method:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    
}

public enum TypeParameters:String {
    case body = "body"
}

public protocol NetworkResource {
    var path:URL { get }
}

extension NetworkResource {
    
    
    func request(completion:@escaping(_ response:Any) -> ()){
        
        //let urlp = "http://www.mocky.io/v2/58ac684c1000002d12514b61"
        let urlp = "http://www.mocky.io/v2/58bb30a11000001f01109e2f"
        Alamofire.request(URL(string:urlp)!).responseJSON { (response) in
            
            // Aquí no emite el valor devuelto
            
            switch response.result {
            case .success:
                completion(response.value)
            case .failure(let error):
                completion(error)
        }

        
    }
    
    }
    
    func downloadImageFromS3(completion:@escaping(_ response:Any) -> ()){
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("myImage.jpg")
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .EUWest1, identityPoolId: "eu-west-1:45da37a2-d874-4a37-b94e-752a9120c937")
        let configuration = AWSServiceConfiguration(region:.EUWest1, credentialsProvider:credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        
        let transferManager = AWSS3TransferManager.default()
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = "pickandgol"
        downloadRequest?.key = "test01.jpg"
        downloadRequest?.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error downloading: \(downloadRequest?.key) Error: \(error)")
                        completion(error)
                    }
                } else {
                    print("Error downloading: \(downloadRequest?.key) Error: \(error)")
                    completion(error)
                }
                return nil
            }
            print("Download complete for: \(downloadRequest?.key)")
            let downloadOutput = task.result
            completion(downloadOutput)
            return nil
        })


    }
    
    
    
}
