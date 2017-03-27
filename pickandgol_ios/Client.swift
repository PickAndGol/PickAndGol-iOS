//
//  Client.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 21/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RxSwift
import AWSS3

public enum ClientError: Error {
    case couldNotDecodeJSON
    case badStatus(Int, String)
}

public class Client{
    
    let disposeBag = DisposeBag()
    func objects(endPoint:NetworkResource) -> Observable<Response> {
        
        return response(endPoint: endPoint)
            .map { response in
                return response
        }
        }
    
private func response(endPoint:NetworkResource) ->Observable<Response>  {
        
        return Observable<Response>.create { (observer) -> Disposable in
            endPoint.request{ (endPointResponse)   in
                
                if let value = endPointResponse as? JSONDictionary {
                    let response:Response = decode(value)!
                    observer.onNext(response)
                    observer.onCompleted()
                }
                
            }
            
            return  Disposables.create()
        }
        
        
    }
    
    public func downloadImage(urlImage:URL) -> Observable<UIImage>{
        
        return Observable<UIImage>.create({ (observer) -> Disposable in
            let network = EventApi(path:URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(urlImage.lastPathComponent), method: .get, body: [:])
            network.downloadImageFromS3(){ data in
               
                if data is AWSS3TransferManagerDownloadOutput {
                    let datos = data as! AWSS3TransferManagerDownloadOutput
                    let url = datos.body as! NSURL
                    let image = UIImage(contentsOfFile: url.path! )!
                    observer.onNext(image)
                    observer.onCompleted()
                }else{
                    let image = UIImage(named: "error_placeholder")!
                    observer.onNext(image)
                    observer.onCompleted()
                }
                
            }
            return  Disposables.create()
        })
        
    }
    
    public func uploadImage(pathFile:URL) -> Observable<Bool>{
        
        return Observable<Bool>.create({ (observer) -> Disposable in
            
            let network = EventApi(path: pathFile, method: .get, body: [:])
            network.uploadImageFromS3(){ data in
                print(data)
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        
        })
        
    }

}
