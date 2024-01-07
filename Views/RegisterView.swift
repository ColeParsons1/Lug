//
//  RegisterView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/13/22.
//

import Foundation
import SwiftUI
import UIKit

//import FirebaseAuth

struct RegisterView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var email: String = ""
    @State var isOpenView = false
    @State var isJobView = false
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "car.fill")
                    .foregroundColor(Color(hex: 0xfc6022)) //FFA500 fc6022
                    .scaledToFill()
                    .font(.system(size: 80))
                    .padding(.bottom, 100)
                    .padding(.top, 100)
                    .opacity(0.89)
                Spacer()
                VStack{
                    TextField("First Name", text: $first_name)
                        .padding()
                        .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                        .foregroundColor(.primary)
                        .accentColor(.black)
                        .cornerRadius(8)
                    TextField("Last Name", text: $last_name)
                        .padding()
                        .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                        .foregroundColor(.primary)
                        .accentColor(.black)
                        .cornerRadius(8)
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                        .foregroundColor(.primary)
                        .accentColor(.black)
                        .cornerRadius(8)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.clear)
                        .accentColor(.black)
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                    Spacer()
                    VStack{
                        NavigationLink(destination: JobFeedView(), isActive: $isJobView) {
                            EmptyView()
                        }.isDetailLink(false)
                        
                    }
                    
                    
                    Button(action: {
                        register()
                        self.isJobView = true
                    }, label:{
                        Text("Register")
                            .frame(width: 250, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                }
            }.navigationBarBackButtonHidden(true)
            .padding()
        }.navigationBarBackButtonHidden(true)
    }
    
    func register() {
        
        guard let url = URL(string: "http://192.168.1.5:8000/register/") else {
                print("api is down")
                return
        }

        let userData = User(id: 0, first_name: self.first_name, last_name: self.last_name, username: self.email, password: self.password, password2: self.password, email: self.email)
        let username = userData.username
        let first_name = userData.first_name
        let last_name = userData.last_name
        let password = userData.password
        let password2 = userData.password
        let email = userData.email
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        print(base64LoginString)
            
            guard let encoded = try? JSONEncoder().encode(userData) else {
                print("failed to encode")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = encoded

            URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            if let response = try? JSONDecoder().decode(User.self, from: data) {
                                DispatchQueue.main.async {
                                    _ = response
                                    //self.function()
                                    //presentationMode.wrappedValue.dismiss()

                                }
                                return
                            }
                        }
                        
                    }.resume()
        
    }
}
