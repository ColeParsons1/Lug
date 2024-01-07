//
//  SubscriptionViewModel.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/28/22.
//

import Foundation
import Foundation
import Stripe
import StripePaymentSheet
import UIKit

class SubscriptionViewModel: ObservableObject, SubscriptionResponseProtocol {
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var errorMessage: String? = nil
    @Published var isApiFailed: Bool = false
    @Published var isSuccessPayment: Bool = false
    
    init() {
        STPAPIClient.shared.publishableKey = AppConstants.STRIPE_PUBLISHING_KEY
    }
    
    func tokenization(name: String) {
        
        //SubscriptionService.getSubscriptionToken(callback: self)
        CheckoutViewController()
        
    }
    
    func onResult(subscriptionResult: SubscriptionResponse) {
        //success result from api
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Lug Delivery Services"
        configuration.customer = .init(id: subscriptionResult.customer, ephemeralKeySecret: subscriptionResult.ephemeralKey)
        configuration.primaryButtonColor = UIColor.init(.blue)
        DispatchQueue.main.async {
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: subscriptionResult.paymentIntent, configuration: configuration)
        }
    }
    
    
    func onError(message: String) {
        //some error during calling the api for tokenization
        self.errorMessage = message
    }
    
    func onPaymentCompletion(result: PaymentSheetResult?) {
          if let paymentFinal = result {
              switch paymentFinal {
              case .completed:
                  isSuccessPayment = true
              case .failed(let error):
                self.errorMessage = error.localizedDescription
                  self.isApiFailed = true
              case .canceled:
                  self.isApiFailed = false
              }
          }
      }
    
}
