//
//  SubscriptionResponseCallback.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/28/22.
//

import Foundation

protocol SubscriptionResponseProtocol {
    
    func onResult(subscriptionResult: SubscriptionResponse)
    func onError(message: String)
    
}
