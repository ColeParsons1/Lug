//
//  PaymentView.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/28/22.
//

import Foundation
import SwiftUI
import Stripe
import StripePaymentSheet
import CoreLocation


struct PaymentView: View {
    
    @StateObject var viewModel: SubscriptionViewModel
    //@StateObject var viewModel2: CheckoutViewController
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
    @State var Price: Float = 0.0
    @State var active: Bool = false
    @State var Distance: Float?
    @State var Total: Float?
    static var id: Int?
    
    var body: some View {
        
        
        //var total = price + 8.00
        //getDistance()
        
        //let sourceParams = STPSourceParams.sofortParams(withAmount: 1099,
                                                        //returnURL: "your-app://stripe-redirect",
                                                        //country: "DE",
                                                        //statementDescriptor: "ORDER AT11990")
        //STPAPIClient.shared.createSource(with: sourceParams, completion: viewModel.onPaymentCompletion)
        
        
        VStack{
            
            Text("Order Details").font(.headline).fontWeight(.bold).frame(maxWidth: .infinity,alignment: .leading).padding(.leading)
            
                
                
            
            HStack{
                
                Text("Company Name").font(.headline).fontWeight(.bold).foregroundColor(.gray)
                
                Spacer()
                
                Text((self.Business_Name!.replacingOccurrences(of: "_", with: " "))).font(.subheadline).fontWeight(.semibold)
                
            }.padding([.leading, .trailing, .top])
            
            HStack{
                
                Text("Load Weight").font(.headline).fontWeight(.bold).foregroundColor(.gray)
                
                Spacer()
                
                Text(String(self.Load_Weight!) + " lbs").font(.subheadline).fontWeight(.semibold)
                
            }.padding([.leading, .trailing, .top])
            
            HStack{
                
                Text("Distance").font(.headline).fontWeight(.bold).foregroundColor(.gray)
                
                Spacer()
                //var d = String(format: "%.2f", price)
                
                Text(String(format: "%.1f", self.Distance ?? 0) + " mi").font(.subheadline).fontWeight(.semibold)
                
            }.padding([.leading, .trailing, .top])
            
            //Divider()
            
           // HStack{
                
                //Text("Delivery Fee").font(.headline).fontWeight(.bold).foregroundColor(.gray)
                
                //Spacer()
                
                //Text(String(price)).font(.subheadline).fontWeight(.semibold)
                
            //}.padding([.leading, .trailing, .top])
            
            Divider()
            
            HStack{
                
                Text("Total").font(.headline).fontWeight(.bold).foregroundColor(.gray)
                
                Spacer()
                //var price = (self.Price ?? 0) + (self.Tip ?? 0)
                let formattedPrice = String(format: "%.2f", self.Price)
                
                Text("$" + formattedPrice).font(.title).fontWeight(.semibold)
                
            }.padding([.leading, .trailing, .top])
            
            
            //payment button part
            if viewModel.paymentSheet != nil {
                
                PaymentSheet.PaymentButton(
                    paymentSheet: viewModel.paymentSheet!,
                    onCompletion: viewModel.onPaymentCompletion
                ) {
                    
                    Button(action: {
                        //SubscriptionService.getSubscriptionToken()
                        //self.viewModel.tokenization(name: "")
                        //checkoutb
                        
                        
                        
                    }, label: {
                        
                        Text("Proceed to Payment").foregroundColor(.white)
                        
                    }).frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.blue))
                    .frame(maxWidth: .infinity)
                    .padding()//.disabled(true)
                }
                
            }else {
                //Button() {

                          //self.active = true
                        //}
                                   
                       //.sheet(isPresented: $active) {
                           //CheckoutPageViewControllerWrapper()
                       //}
                //CheckoutView.PaymentButton(
                //paymentSheet: viewModel2.paymentSheet!,
                //onCompletion: viewModel2.didTapCheckoutButton,
                //content: <#T##() -> String?#>
               //)
                    //paymentSheet: viewModel.paymentSheet ?? <#default value#>,
                    //onCompletion: viewModel.onPaymentCompletion
                //) {
                //CheckoutViewController()
                //VStack{ //username: self.username
                VStack{
                    NavigationLink(destination: CheckoutPageViewControllerWrapper(), isActive: $active) {
                        EmptyView()
                    }.isDetailLink(false)
                }
                //}
                    Button(action: {
                        //SubscriptionService.getSubscriptionToken(callback: SubscriptionResponseProtocol.self as! SubscriptionResponseProtocol)
                        //self.viewModel.tokenization(name: "")
                        //CheckoutViewController()
                        print("pressed")
                        self.active.toggle()
                        
                        
                    }, label: {
                        
                        Text("Proceed to Payment").foregroundColor(.white)
                        
                    }).frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(Color(hex: 0xfc6022).opacity(0.87)))
                        .frame(maxWidth: .infinity)
                        .padding()//.disabled(true)
                    
                //}
            }
        }.onAppear(perform: getDistance)
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
                        
                        for item in jobs{
                            print(item.Business_Name)
                            if let i: Job = jobs.first(where: { element in element.Business_Name == self.Business_Name!.replacingOccurrences(of: "_", with: " ") }) {
                                 
                                Distance = i.Distance
                                self.Price = i.Price//Distance! * 3.02
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

struct CheckoutView: UIViewControllerRepresentable {
     
    func makeUIViewController(context: Context) -> CheckoutViewController {
           return CheckoutViewController()
       }
      
    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {
    }
    
    
}

struct CheckoutPageViewControllerWrapper: UIViewControllerRepresentable {

  typealias UIViewControllerType = CheckoutPageViewController
    //@State var ID: Int = PaymentView.id ?? 0

  func makeUIViewController(context: UIViewControllerRepresentableContext<CheckoutPageViewControllerWrapper>) -> CheckoutPageViewControllerWrapper.UIViewControllerType {
      return CheckoutPageViewController()
 }
func updateUIViewController(_ uiViewController: CheckoutPageViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<CheckoutPageViewControllerWrapper>) {
   
} }

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(viewModel: SubscriptionViewModel())
    }
}
