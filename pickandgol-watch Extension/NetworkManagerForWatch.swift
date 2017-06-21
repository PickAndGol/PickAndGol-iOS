//
//  NetworkManagerForWatch.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 12/6/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation


enum networkManagerForWatchError: Error {
    case badResponse
    case noResponse
    case other
}


final class networkManagerForWatch {
    
    let session:URLSession
    let rootEndPoint:URL

    init(_ rootEndPoint: URL) {
        self.rootEndPoint = rootEndPoint
        
        let configuratioSession = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuratioSession)
        
    }
    

    func executeJsonRequest(endPoint:String, method:HTTPMethod, completion: @escaping (_ dictionary:Response?, _ error: NSError?) -> Void){
    
        if let url = requestWithURLString(endPoint) {
            
            
            // Create Task
            let task = self.session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    completion(nil, error as NSError?)
                    return
                }
                
                // Check to see if there was an HTTP Error
                let cleanResponse = self.checkResponseForErrors(response)
                if let errorCode = cleanResponse.errorCode {
                    print("An error occured: \(errorCode)")
                    completion(nil, error as NSError?)
                    return
                }

                // Make sure you got an array back after parsing
                guard let dataJson:Response = decode(data!) else {
                    print("Parsing Issues")
                    completion(nil, error as NSError?)
                    return
                }
                 //let jsonResponse:Response = decode(data!)!
                // Things went well, call the completion handler
                completion(dataJson, error as NSError?)
            
                
            }
            task.resume()
            
        }
        
       
    
    
    }
    
    
    
    // Util function
    
    private func requestWithURLString(_ string: String) -> URLRequest? {
        if let url = URL(string: string, relativeTo: rootEndPoint) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    func checkResponseForErrors(_ response: URLResponse?) -> (httpResponse: HTTPURLResponse?, errorCode: networkManagerForWatchError?) {
        // Make sure there was an actual response
        guard response != nil else {
            return (nil, networkManagerForWatchError.noResponse)
        }
        
        // Convert the response to an `NSHTTPURLResponse` (You can do this because you know that you are making HTTP calls in this scenario, so the cast will work.)
        guard let httpResponse = response as? HTTPURLResponse else {
            return (nil, networkManagerForWatchError.badResponse)
        }
        
        // Check to see if the response contained and HTTP response code of something other than 200
        let statusCode = httpResponse.statusCode
        guard statusCode == 200 else {
            return (nil, networkManagerForWatchError.other)
        }
        
        return (httpResponse, nil)
}
    
    
}
