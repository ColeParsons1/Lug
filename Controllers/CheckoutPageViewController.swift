//
//  CheckoutPageViewController.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/30/22.
//

import Foundation
import SwiftUI
import UIKit
import Stripe
import Alamofire
import StripePaymentSheet


class CheckoutPageViewController: UIViewController {
    
    @State var jobs = [Job]();
    @State var item: Job?
    @State var Business_Name: String?
    @State var Job_Type: String = ""
    @State var Load_Weight: String?
    @State var Description: String = ""
    @State var Pieces: String = ""
    @State var Pickup_Date = Date()
    @State var Pickup_Time = Date()
    @State var Pickup_Address: String = ""
    @State var Destination_Address: String = ""
    @State var Latitude_Pickup: Double = 0.0
    @State var Longitude_Pickup: Double = 0.0
    @State var Latitude_Destination: Double = 0.0
    @State var Longitude_Destination: Double = 0.0
    @State var Date_Needed: String = ""
    @State var Tip: Double = 0
    @State var Price: Double = 0
    @State var active: Bool = false
    @State var Distance: Float?
    @State var Total: Float?
    static var id: Int?
    
    var setupIntentClientSecret: String?
    //@State var ID: Int?
    //var viewModel: SubscriptionViewModel?
    private var paymentIntentClientSecret: String?

     //lazy var cardTextField: STPPaymentCardTextField = {
     //let cardTextField = STPPaymentCardTextField()
     //return cardTextField
       //}()
lazy var payButton: UIButton = {
      let button = UIButton(type: .custom)
       button.layer.cornerRadius = 5
       button.backgroundColor = UIColor(Color(hex: 0xfc6022).opacity(0.87))
       button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
       button.setTitle("Submit Payment", for: .normal)
       button.addTarget(self, action: #selector(pay), for: .touchUpInside)
    return button
}()
lazy var emailTextField: UITextField = {
    let emailTextField = UITextField()
    emailTextField.placeholder = String(PaymentView.id!)
    emailTextField.borderStyle = .roundedRect
    return emailTextField
}()
lazy var mandateLabel: UILabel = {
    let mandateLabel = UILabel()
    mandateLabel.text = "I authorize Lug Delivery Services, LLC to send instructions to the financial institution that issued my card to take payments from my account in accordance with the terms of service."
    mandateLabel.numberOfLines = 0
    mandateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    mandateLabel.textColor = .systemGray
    return mandateLabel
}()

override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    //self.ID = PaymentView.id
    let stackView = UIStackView(arrangedSubviews: [emailTextField, payButton, mandateLabel])
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
        stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
        view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
        stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
    ])
    
    //HandlePayment()//.startCheckout()
    fetchPaymentIntent()
    //pay()
    
}
    
    func fetchPaymentIntent() {
            //let url = Self.backendURL.appendingPathComponent("/create-payment-intent")

            let shoppingCartContent: [String: Any] = [
                "items": [
                    ["id": PaymentView.id]
                ]
            ]
        
        let jobData = Job(id: PaymentView.id ?? 0, Business_Name: "", Job_Type: "", Load_Weight: 0, Description: "", Pieces: 0, ImageString: "", Image: "", Pickup_Address: "", Destination_Address: "", Date_Needed: "", Tip: 0, Price: 0, Latitude_Pickup: 0, Longitude_Pickup: 0, Latitude_Destination: 0, Longitude_Destination: 0, Distance: 0, Created: "", InProgress: false, Complete: false, Assigned_Lugger: "")
        
        guard let encoded = try? JSONEncoder().encode(jobData) else {
               print("api is down")
               return
         }
        
        let cardParams = STPCardParams()
        cardParams.name = "Ass"
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 12
        cardParams.expYear = 26
        cardParams.cvc = "424"
        
        let sourceParams = STPSourceParams.cardParams(withCard: cardParams)
        STPAPIClient.shared.createSource(with: sourceParams) { (source, error) in
            if let s = source, s.flow == .none && s.status == .chargeable {
                //self.createBackendChargeWithSourceID(s.stripeID)
            }
        }
        
        var request = URLRequest(url: URL(string: "http://192.168.1.5:8000/checkout/")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("5Buydmz1hCk7nUaKWP5Oy2T3SJ8wwozl7cz31YUNXNQBqwKS7CgABXmJAv8iYDBO", forHTTPHeaderField: "X-CSRFToken")
            request.httpBody = try? JSONSerialization.data(withJSONObject: shoppingCartContent)

            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let clientSecret = json["paymentIntent"] as? String
                else {
                    let message = error?.localizedDescription ?? "Failed to decode response from server."
                    self?.displayAlert(title: "Error loading page", message: message)
                    return
                }

                print("Created PaymentIntent")
                self?.paymentIntentClientSecret = clientSecret

                DispatchQueue.main.async {
                    self?.payButton.isEnabled = true
                }
            })

            task.resume()
        //pay()
        }
    
    @objc
        func pay() {
            guard let paymentIntentClientSecret = self.paymentIntentClientSecret else {
                print("L")
                return
            }

            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Lug Delivery Services LLC"


            let paymentSheet = PaymentSheet(
                paymentIntentClientSecret: paymentIntentClientSecret,
                configuration: configuration)

            paymentSheet.present(from: self) { [weak self] (paymentResult) in
                switch paymentResult {
                case .completed:
                    self?.displayAlert(title: "Payment complete!")
                case .canceled:
                    print("Payment canceled!")
                case .failed(let error):
                    self?.displayAlert(title: "Payment failed", message: error.localizedDescription)
                }
            }
        }
    
    func displayAlert(title: String, message: String? = nil) {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true)
            }
        }
    
    func getDistance(){
        
        
        guard let url = URL(string: "http://192.168.1.5:8000/jobs/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        request.addValue("58wgEeCeXMVk6iN2bSmKukfs3UnfSOkXMNEpKKdOPF9PriscLpKhGyWyo7ePCypt", forHTTPHeaderField: "X-CSRFToken")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        self.jobs = response
                        print(self.Business_Name!)
                        
                        for item in self.jobs{
                            print(item.Business_Name)
                            if let i: Job = self.jobs.first(where: { element in element.Business_Name == self.Business_Name!.replacingOccurrences(of: "_", with: " ") }) {
                                 
                                self.Distance = i.Distance
                                self.Total = i.Price+i.Tip//Distance! * 3.02
                                PaymentView.id = i.id
                                
                                }

                                
                        }
                    }
                    return
                }
            }
            
        }.resume()
        
        
        //self.Distance = j!.Distance
        
        //self.Distance = distanceInMiles
        //print(self.Distance)
        
        
        //return Distance!
        
    }
                                              
}
