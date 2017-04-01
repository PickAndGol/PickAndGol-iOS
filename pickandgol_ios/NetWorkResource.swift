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
        
        /*let headers = [
            "Content-Type":"application/json; charset=utf-8",
            ]*/
       
        
       // No puedo pasar el parametro method de manera dinamica tengo que cometer esta aberración por el momento!!!!!!!!

        switch self.methodRequest {
        case .get:
            Alamofire.request(self.path, method: .get ,parameters:self.body)
                .validate()
                .responseJSON { response in
                    
                    if (response.result.error == nil) {
                        //debugPrint("HTTP Response Body: \(response.data!)")
                        completion(response.value as Any)
                    }
                    else {
                        //debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                        completion(response.error as Any)
                    }
            }
        
        case .post:            
            Alamofire.request(self.path, method: .post ,parameters:self.body)
                .validate()
                .responseJSON { response in
                    
                    if (response.result.error == nil) {
                        //debugPrint("HTTP Response Body: \(response.data!)")
                        completion(response.value as Any)
                    }
                    else {
                        //debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                        completion(response.error as Any)
                    }
            }
        case .put:
            Alamofire.request(self.path, method: .put ,parameters:self.body)
                .validate()
                .responseJSON { response in
                    
                    if (response.result.error == nil) {
                        //debugPrint("HTTP Response Body: \(response.data!)")
                        completion(response.value as Any)
                    }
                    else {
                        //debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                        completion(response.error as Any)
                    }
            }
        
        default:
            print("ERROR")
            
        }
        
       
    
        
    }
    
    
    
    
    
    
    func downloadImageFromS3(completion:@escaping(_ response:Any) -> ()){
      
        
        let sessionAWSS3 = S3ConfigSingleton.sharedInstance
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .EUWest1, identityPoolId: "eu-west-1:45da37a2-d874-4a37-b94e-752a9120c937")
        let configuration = AWSServiceConfiguration(region:.EUWest1, credentialsProvider:credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        
        let transferManager = AWSS3TransferManager.default()
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = sessionAWSS3.bucket
        downloadRequest?.key = self.path.lastPathComponent
        downloadRequest?.downloadingFileURL = self.path
        
        transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        //print("Error downloading: \(String(describing: downloadRequest?.key)) Error: \(error)")
                        completion(error)
                    }
                } else {
                    //print("Error downloading: \(String(describing: downloadRequest?.key)) Error: \(error)")
                    completion(error)
                }
                return nil
            }
            //print("Download complete for: \(String(describing: downloadRequest?.key))")
            let downloadOutput = task.result
            completion(downloadOutput as Any)
            return nil
        })

    }
    
    func uploadImageFromS3(completion:@escaping(_ response:Any) -> ()){
        
        let sessionAWSS3 = S3ConfigSingleton.sharedInstance
        let transferManager = AWSS3TransferManager.default()
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        
        uploadRequest?.bucket = sessionAWSS3.bucket
        uploadRequest?.key = self.path.lastPathComponent
        uploadRequest?.body = self.path
      
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        //print("Error downloading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                        completion(error)
                    }
                } else {
                    //print("Error downloading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                    completion(error)
                }
                return nil
            }
            //print("Download complete for: \(String(describing: uploadRequest?.key))")
            let uploadOutput = task.result
            completion(uploadOutput as Any)
            return nil
        })
        
    }
    
    
    
}
