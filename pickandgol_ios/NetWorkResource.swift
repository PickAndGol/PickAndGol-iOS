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


public protocol NetworkResource {
    var path:URL { get }
    var methodRequest:HTTPMethod {get}
    var body:[String:String] {get}
}

extension NetworkResource {
    

    func request(completion:@escaping(_ response:Any) -> ()){
        
        let headers = [
            "Content-Type":"application/json; charset=utf-8",
            ]
       
        
       // No puedo pasar el parametro method de manera dinamica tengo que cometer esta aberración por el momento!!!!!!!!

        switch self.methodRequest {
        case .get:
            Alamofire.request(self.path, method: .get ,parameters:self.body)
                .validate()
                .responseJSON { response in
                    
                    if (response.result.error == nil) {
                        debugPrint("HTTP Response Body: \(response.data!)")
                        completion(response.value)
                    }
                    else {
                        debugPrint("HTTP Request failed: \(response.result.error)")
                        completion(response.error)
                    }
            }
        
        case .post:            
            Alamofire.request(self.path, method: .post ,parameters:self.body)
                .validate()
                .responseJSON { response in
                    
                    if (response.result.error == nil) {
                        debugPrint("HTTP Response Body: \(response.data!)")
                        completion(response.value)
                    }
                    else {
                        debugPrint("HTTP Request failed: \(response.result.error)")
                        completion(response.error)
                    }
            }
        
        default:
            print("ERROR")
            
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
