//
//  NetworkManager.swift
//  GeekMobile
//
//  Created by Egor on 16.04.2021.
//

import Foundation
import RxSwift
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    var i = 0
    
    private init() {
        
    }
    
    func makeRequest(url: String, params: Parameters = [:], completion: @escaping (URLRequest) -> Void) {
        
        AF.request(url, parameters: params).response { response in
            
            guard let originalRequest = response.request else { return }
            completion(originalRequest)
        }
    }
    
    func makeRequest(url: String, params: Parameters = [:]) -> Observable<Data> {
        
        return Observable.create { observer -> Disposable in
            
            AF.request(url, parameters: params).response { response in
                
                if (response.request!.url!.absoluteString.contains("photos.getAll")) {
                    //print(response.request!)
                    //print(self.i)
                    //self.i += 1
                }
                if let error = response.error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let data = response.data else { return }
                                
                observer.onNext(data)
            }
            
            return Disposables.create()
        }
    }
}
