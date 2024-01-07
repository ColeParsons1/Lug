//
//  SubscriptionService.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/28/22.
//

import Foundation
import SwiftUI
import UIKit
import Alamofire

struct SubscriptionService {
    
    //static var API_ENDPOINT = URL(string: "
    
    private static let API_ENDPOINT = "http://192.168.1.5:8000/"
        
    static func getSubscriptionToken(callback: SubscriptionResponseProtocol){
            
            
            AF.request("\(API_ENDPOINT)checkout/", method: .post, headers:APIManager.headers()).responseDecodable(of: SubscriptionResponse.self){response in
                
                //AF.request.addValue("zhrfrBBihSOfj5Y5tHH0iRu1qUJlfm7Vamu8IRXt7fHGtboR1sw9fW6KgliMXNSh", forHTTPHeaderField: "X-CSRFToken")
                
                guard let result  = response.value else {
                    
                    callback.onError(message: response.error?.errorDescription ?? "Something went wrong, please try again!")
                    return
                }
                //print(name)
                print(result)
                callback.onResult(subscriptionResult: result)
                
                //getURL(url: result.url)
                
            }
        }
    
    static func getURL(url: String) {
        guard let url = URL(string: url) else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(SubscriptionResponse.self, from: data) {
                    DispatchQueue.main.async {
                        _ = response
                        
                        
                        
                    }
                    return
                }
            }
            
        }.resume()
        
        
    }
    }

class APIManager {

    class func headers() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "X-CSRFToken": "5Buydmz1hCk7nUaKWP5Oy2T3SJ8wwozl7cz31YUNXNQBqwKS7CgABXmJAv8iYDBO",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        //if let authToken = UserDefaults.standard.string(forKey: "auth_token") {
            //headers["Authorization"] = "Token" + " " + authToken
        //}

        return headers
    }
}
    
    
    

