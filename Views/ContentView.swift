//
//  ContentView.swift
//  MainRoot
//
//  Created by Cole Parsons on 10/27/22.
//

import SwiftUI
import Foundation
import UIKit

//import FirebaseAuth

struct ContentView: View {
    @State var profiles = [Account]();
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var isOpenView = false
    @State var isAddView = false
    @State var isRegisterView = false
    @State var isJobView = false
    @State var isPostView = false
    @State var isBusinessView = false
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "car.fill")
                    .foregroundColor(Color(hex: 0xfc6022)) //FFA500 fc6022
                    .scaledToFill()
                    .font(.system(size: 90))
                    .padding(.bottom, 100)
                    .padding(.top, 100)
                    .opacity(1.0)
                Spacer()
                VStack{
                    //TextField("username", text: $username)
                        //.padding()
                        //.background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                        //.foregroundColor(.primary)
                        //.accentColor(.primary)
                        //.cornerRadius(8)
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                        .foregroundColor(.primary)
                        .accentColor(.primary)
                        .cornerRadius(8)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.clear)
                        .accentColor(.primary)
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                    Spacer()
                    VStack{ //username: self.username
                        NavigationLink(destination: NewJobFeedView(), isActive: $isJobView) {
                            EmptyView()
                        }.isDetailLink(false)
                    }
                    VStack{ //username: self.username
                        NavigationLink(destination: BusinessView(), isActive: $isBusinessView) {
                            EmptyView()
                        }.isDetailLink(false)
                    }
                    VStack{ //username: self.username
                        //NavigationLink(destination: JobAddView(function: loadAccount, InProgress: false, Complete: false), isActive: $isAddView) {}
                        NavigationLink(destination: JobAddView(function: loadAccount, InProgress: false, Complete: false), isActive: $isAddView)  {
                            EmptyView()
                        }.isDetailLink(false)
                    }
                    VStack{ //username: self.username
                        NavigationLink(destination: RegisterView(), isActive: $isRegisterView) {
                            EmptyView()
                        }.isDetailLink(false)
                    }
                    VStack {
                       Spacer()
                        
                        Button(action: {
                            self.isRegisterView = true
                            //register()
                        }){
                            Text("New To Lug? Register Here")
                                .foregroundColor(Color(hex: 0xfc6022))
                        }
                        
                    }
                    
                    Button(action: {
                        self.isAddView = true
                        login()
                    }, label:{
                        Text("Sign In")
                            .frame(width: 250, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color(hex: 0xfc6022))
                            .cornerRadius(8)
                    })
                }
            }.onAppear(perform: loadAccount)
                
            
            .padding()
        }.onAppear(perform: loadAccount).navigationBarBackButtonHidden(true)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func login() {
        
        guard let url = URL(string: "http://192.168.1.5:8000/login/") else {
                print("api is down")
                return
        }

        let userData = User(id: 0, first_name: "", last_name: "", username: self.email, password: self.password, password2: self.password, email:self.email)
        
        let username = userData.username
        let password = userData.password
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        print(base64LoginString)
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        _ = response
                    }
                    return
                }
            }
            
        }.resume()
            //request.addValue("58wgEeCeXMVk6iN2bSmKukfs3UnfSOkXMNEpKKdOPF9PriscLpKhGyWyo7ePCypt", forHTTPHeaderField: "X-CSRFToken")
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            //request.httpBody = encoded
            //request.setValue("Token db058f23ecc70f4fa3de4ac69a04dc48bb7579a63aea1ad3d038ce59b1511890", forHTTPHeaderField: "Authorization")

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
    
    
    func loadAccount() {
        guard let url = URL(string: "http://192.168.1.5:8000/profiles/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Account].self, from: data) {
                    DispatchQueue.main.async {
                        self.profiles = response
                        if profiles[0].Account_Type == 1 {
                            self.isAddView = true
                            //self.isBusinessView = false
                            //self.isJobView = true
                        }
                        if profiles[0].Account_Type == 2 {
                            //self.isJobView = true
                            //self.isJobView = false
                            //self.isBusinessView = true
                            self.isAddView = true
                            //self.isPostView = true
                            //self.isJobView = true
                        }
                        else{
                            self.isAddView = true
                        }
                        
                    }
                    return
                }
            }
            
        }.resume()
        
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

