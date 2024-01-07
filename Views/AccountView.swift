//
//  AccountView.swift
//  MainRoot
//
//  Created by Cole Parsons on 10/29/22.
//

import Foundation
import SwiftUI
import UIKit
import MapKit

struct AccountView : View {
    @State var profiles = [Account]();
    @State var jobs = [Job]();
    @State var username: String = ""
    @State var password: String = ""
    @State var location = [City]();
    @State var logoutPressed = false
    @State var calendarPressed = false
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    List(profiles, id: \.id) {item in
                        
                        Text(item.user)
                            .font(.system(size: 24.0, weight: .light))
                            .foregroundColor(Color.white)
                        Text("Basic Info")
                            .font(.system(size: 24.0, weight: .light))
                            .foregroundColor(Color.white)
                        Text("Completed Jobs")
                            .font(.system(size: 24.0, weight: .light))
                            .foregroundColor(Color.white)
                        Text("Payment Methods")
                            .font(.system(size: 24.0, weight: .light))
                            .foregroundColor(Color.white)
                    }
                }
                    
                    
                    VStack{ //username: self.username
                        NavigationLink(destination: ContentView(), isActive: $logoutPressed) {
                            EmptyView()
                        }
                        
                    }
                    Button(action: {
                        self.logoutPressed = true
                        logout()
                    }){
                        Text("Logout")
                            .font(.system(size: 20.0, weight: .light))
                            .foregroundColor(Color.red)
                    }
                    .font(.system(size: 28.0, weight: .light))
                    .foregroundColor(Color.white)
                }.onAppear(perform: loadAccount).navigationTitle("Account").padding(.top, 100)
                
            }//.onAppear(perform: getLocations)
        }
    
    func getLocations() {
        let url = URL(string: "http://192.168.1.5:8000/jobs/")
        
        var req = URLRequest(url: url!)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        req.addValue("58wgEeCeXMVk6iN2bSmKukfs3UnfSOkXMNEpKKdOPF9PriscLpKhGyWyo7ePCypt", forHTTPHeaderField: "X-CSRFToken")
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        self.jobs = response
                        for item in jobs {
                            //self.mapView = MKMapView()
                            let lat_pickup = Double(item.Latitude_Pickup)
                            let lon_pickup = Double(item.Longitude_Pickup)
                            
                            let annotations = [
                                City(name: item.Business_Name, coordinate: CLLocationCoordinate2D(latitude: lat_pickup, longitude: lon_pickup))
                            ]
                            
                            self.location = annotations
                            //return
                        }
                        //return
                        
                    }
                    
                }
                
            }
            
        }.resume()
        //return
        
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
                        }
                        return
                    }
                }
                //getLocations()
                
            }.resume()
            
        }
        
        func logout() {
            
            guard let url = URL(string: "http://192.168.1.5:8000/logout/") else {
                print("api is down")
                return
            }
            
            let userData = User(id: 0, first_name: "", last_name: "", username: self.username, password: self.password, password2: self.password, email:"")
            let username = userData.username
            let password = userData.password
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
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
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
        
        
    }
    
struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
