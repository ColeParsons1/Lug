//
//  CheckoutViewController.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/29/22.
//

import Foundation
import UIKit
import StripePaymentSheet

class CheckoutViewController: UIViewController {
  @IBOutlet weak var checkoutButton: UIButton?
  var paymentSheet: PaymentSheet?
  let backendCheckoutUrl = URL(string: "http://192.168.1.4:8000/checkout/")! // Your backend endpoint

  override func viewDidLoad() {
    super.viewDidLoad()

      checkoutButton?.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
      checkoutButton?.isEnabled = false

    // MARK: Fetch the PaymentIntent client secret, Ephemeral Key secret, Customer ID, and publishable key
    var request = URLRequest(url: backendCheckoutUrl)
      request.addValue("oyxq9lGbaTWraCeHDJD0tvmtPfgiJuR31YahDVFE7G3gyj4Ph80Hl5nMRjjbcd17", forHTTPHeaderField: "X-CSRFToken") 
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let customerId = json["customer"] as? String,
            let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
            let paymentIntentClientSecret = json["paymentIntent"] as? String,
            let publishableKey = json["publishableKey"] as? String,
            let self = self else {
        // Handle error
        return
      }

      STPAPIClient.shared.publishableKey = publishableKey
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Lug Delivery Services"
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
      // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
      // methods that complete payment after a delay, like SEPA Debit and Sofort.
      configuration.allowsDelayedPaymentMethods = true
      self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)

      DispatchQueue.main.async {
        self.checkoutButton?.isEnabled = true
      }
    })
    task.resume()
  }
    
    @objc
    func didTapCheckoutButton() {
      // MARK: Start the checkout process
      paymentSheet?.present(from: self) { paymentResult in
        // MARK: Handle the payment result
        switch paymentResult {
        case .completed:
          print("Your order is confirmed")
        case .canceled:
          print("Canceled!")
        case .failed(let error):
          print("Payment failed: \(error)")
        }
      }
    }
    
    

}
