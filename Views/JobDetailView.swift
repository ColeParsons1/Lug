//
//  JobDetailView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/1/22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

struct JobDetailView : View {
    
    
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    
    @State var jobs = [Job]();
    //@State var directions: String = ""
    @State var isOpenView: Bool = false
    @State var isOpenNav: Bool = false
    @State var showSettings: Bool = false
    @State var showPic: Bool = false
    //@State var pushed: Bool
    @State var item: Job
    
    
    
    var body: some View {
            NavigationView{
                    VStack(alignment:.leading) {
                        MapView(latitude_pickup:item.Latitude_Pickup, longitude_pickup:item.Longitude_Pickup, latitude_destination: item.Latitude_Destination, longitude_destination: item.Longitude_Destination, pickup_address: item.Pickup_Address, destination_address: item.Destination_Address, business_name: item.Business_Name).frame(maxWidth: .infinity, maxHeight: .infinity).cornerRadius(0.0).padding(.bottom, 100.0).zIndex(-100)
                        NavigationLink(destination: MapView(latitude_pickup:item.Latitude_Pickup, longitude_pickup:item.Longitude_Pickup, latitude_destination: item.Latitude_Destination, longitude_destination: item.Longitude_Destination, pickup_address: item.Pickup_Address, destination_address: item.Destination_Address), isActive: $isOpenView) {
                            EmptyView()
                        }.navigationBarBackButtonHidden(false).navigationBarTitleDisplayMode(.inline)
                        VStack{
                            Text("Swipe Down To Return")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 11.0))
                                .padding(.bottom, 0)
                            //Image(systemName: "arrow.down")
                                //.multilineTextAlignment(.center)
                                //.font(.system(size: 10.0))
                                //.padding(.top, 0.2)
                        }.frame(maxWidth: .infinity, alignment: .center).padding(.top, -90)
                        HStack{
                            Text("\(item.Business_Name)")
                                .font(.system(size: 30.0))
                                .foregroundColor(Color.white)
                                .padding(.top, -80)
                            //Text("Job ID:" + " " + (String(item.id)))
                                //.font(.system(size: 12.0))
                                //.foregroundColor(Color.secondary)
                                //.multilineTextAlignment(.trailing)
                        }.frame(maxWidth: .infinity, alignment: .center)
                        Button(action: {
                            //self.isOpenView = true
                            //self.acceptJob(job: item)
                            self.assign(job: item)
                        }){
                            Text("Claim This Job")
                                .frame(width: 150, height: 40, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color(hex: 0xfc6022))
                                .cornerRadius(8)
                        }.frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 8.0).padding(.top, -50)
                        HStack{
                            Text("Type:")
                                .font(.system(size: 16.0, weight: .regular))
                                .foregroundColor(Color.secondary.opacity(1.0))
                                .padding(.top, 0.0)
                                .opacity(1.0)
                                .frame(maxWidth:.infinity, alignment: .leading)
                            Text(item.Job_Type)
                                .font(.system(size: 16.0, weight: .regular))
                                .foregroundColor(Color.primary)
                                .padding(.bottom, 0.0)
                                .frame(maxWidth:.infinity, alignment: .trailing)
                            Text("Weight:")
                                .font(.system(size: 16.0, weight: .regular))
                                .foregroundColor(Color.secondary.opacity(1.0))
                                .opacity(1.0)
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .padding(.bottom, 0.0)
                                .padding(.top, 0.3)
                            Text((String(item.Load_Weight)) + " lbs")
                                .font(.system(size: 16.0, weight: .regular))
                                .foregroundColor(Color.primary)
                                .padding(.bottom, 0.0)
                                .frame(maxWidth:.infinity, alignment: .trailing)
                        }.frame(maxWidth: .infinity).padding(0).edgesIgnoringSafeArea(.all)
                        let formattedDistance = String(format: "%.1f", item.Distance)
                        HStack{
                            Text("Distance:")
                                .font(.system(size: 16.0, weight: .regular))
                                .foregroundColor(Color.secondary.opacity(1.0))
                                .opacity(1.0)
                                .padding(.trailing, 0.0)
                                .frame(maxWidth:.infinity, alignment: .leading)
                            Text((String(formattedDistance)) + " mi")
                                .font(.system(size: 16.0, weight: .regular))
                                .foregroundColor(Color.primary)
                                .padding(.bottom, 0.0)
                                .frame(maxWidth:.infinity, alignment: .trailing)
                            if (item.Tip != 0){
                                let p = (item.Distance * 1.02) + item.Tip
                                let formattedPay = String(format: "%.2f", p)
                                let t = String(format: "%.2f", item.Tip)
                                //let formattedTip = " + $" + (String(t)) + " Tip"
                                Text("Pay:")
                                    .font(.system(size: 16.0, weight: .regular))
                                    .foregroundColor(Color.secondary.opacity(1.0))
                                    .opacity(1.0)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .padding(.bottom, 0.0)
                                    .padding(.top, 0.5)
                                Text("$" + (String(formattedPay)))
                                    .font(.system(size: 15.0, weight: .regular))
                                    .foregroundColor(Color.primary)
                                    .padding(.bottom, 0.0)
                                    .frame(maxWidth:.infinity, alignment: .trailing)
                            }
                            if (item.Tip == 0){
                                let p = item.Distance * 1.02
                                let formattedPay = String(format: "%.2f", p)
                                Text("Pay")
                                    .font(.system(size: 16.0, weight: .regular))
                                    .foregroundColor(Color.secondary.opacity(1.0))
                                    .opacity(1.0)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                Text("$" + (String(formattedPay)))
                                    .font(.system(size: 16.0, weight: .regular))
                                    .foregroundColor(Color.primary)
                                    .frame(maxWidth:.infinity, alignment: .trailing)
                            }
                        }
                        if !item.ImageString.contains("nil"){
                            Text("View Image")
                                .onTapGesture{
                                  self.showPic.toggle()
                                }.sheet(isPresented: $showPic, content: {
                                  Image(systemName: "person.fill")
                                    .data(url: URL(string:"http:/192.168.1.5:8000/" + item.Image)!)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .listRowSeparator(.hidden)
                                    .scaledToFill()
                                    .scaleEffect()
                                    .edgesIgnoringSafeArea(.all)
                               })
                        }
                        HStack{
                            
                            Button(action: {
                                getDirectionsToPickup(pickup_latitude: item.Latitude_Pickup, pickup_longitude: item.Longitude_Pickup, destination_latitude: item.Latitude_Destination, destination_longitude: item.Longitude_Destination)
                            }){
                                Text("Go To Pickup")
                                    .frame(width: 150, height: 40, alignment: .center)
                                    .foregroundColor(Color.white)
                                    .background(Color(hex: 0xfc6022))
                                    .cornerRadius(8)
                            }.frame(maxWidth: .infinity)
                            Button(action: {
                                getDirectionsToDestination(pickup_latitude: item.Latitude_Pickup, pickup_longitude: item.Longitude_Pickup, destination_latitude: item.Latitude_Destination, destination_longitude: item.Longitude_Destination)
                            }){
                                Text("Go To Dropoff")
                                    .frame(width: 150, height: 40, alignment: .center)
                                    .foregroundColor(Color.white)
                                    .background(Color(hex: 0xfc6022))
                                    .cornerRadius(8)
                            }.frame(maxWidth: .infinity)
                        }.frame(maxWidth: .infinity, alignment: .center)

                    }.foregroundColor(Color(hex: 0xfc6022))
                        .cornerRadius(0)
                        .padding(.top, 0)
                
                
            }.navigationBarBackButtonHidden(false).navigationBarTitleDisplayMode(.inline).foregroundColor(Color.blue)
                .edgesIgnoringSafeArea([.leading, .trailing, .top, .bottom])
                .foregroundColor(Color.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarItems(trailing: Button(action: {showSettings.toggle()}, label: {
            Image(systemName: "gearshape.fill")
                 .zIndex(100.0)
                 .padding(.trailing, -2.0)
                 .padding(.leading, 20.0)
                 .padding(.bottom, 0.0)
                 .padding(.top, -61.0)
                 .foregroundColor(Color.secondary)
                 .onTapGesture{
                     showSettings = true
                     print("Settings")
                 }})).sheet(isPresented: $showSettings){
                SettingsView()
            }
            .listRowSeparatorTint(Color(hex: 0xfc6022).opacity(0.0))
    }
    
    func getDirectionsToPickup(pickup_latitude: Float, pickup_longitude: Float, destination_latitude: Float, destination_longitude: Float) {
        let url = URL(string: "maps://?saddr=&daddr=\(pickup_latitude),\(pickup_longitude)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    return
                }.resume()
            
            
        
            
        
    }
    
    func getDirectionsToDestination(pickup_latitude: Float, pickup_longitude: Float, destination_latitude: Float, destination_longitude: Float) {
        let url = URL(string: "maps://?saddr=&daddr=\(destination_latitude),\(destination_longitude)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    return
                }.resume()
            
            
        
            
        
    }
    
    
 
    func loadJobFeed() {
        guard let url = URL(string: "http://146.190.222.176:8000/jobs/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        self.jobs = response
                    }
                    return
                }
            }
            
        }.resume()
        
    }
    
    func assign(job: Job) { //146.190.222.176:8000
        guard let url = URL(string: "http://192.168.1.2:8000/acceptjob/?q=\(job.id)") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        self.jobs = response
                    }
                    return
                }
            }
            
        }.resume()
        
    }
    
    func acceptJob(job: Job) {
        guard let url = URL(string: "http://146.190.222.176:8000/jobs/") else {
            print("api is down")
            return
        }
        
        let jobData = Job(id: job.id, Business_Name: job.Business_Name, Job_Type: job.Job_Type, Load_Weight: job.Load_Weight, Description: job.Description, Pieces: job.Pieces, ImageString: job.ImageString, Image: "", Pickup_Address: job.Pickup_Address, Destination_Address: job.Destination_Address, Date_Needed: job.Date_Needed, Tip: job.Tip, Price: job.Price, Latitude_Pickup: job.Latitude_Pickup, Longitude_Pickup: job.Longitude_Pickup, Latitude_Destination: job.Latitude_Destination, Longitude_Destination: job.Longitude_Destination, Distance: job.Distance, Created: job.Created, InProgress: false, Complete: false, Assigned_Lugger: "")
       
       guard let encoded = try? JSONEncoder().encode(jobData) else {
                   print("Failed to encode order")
                   return
               }
        
        let username = "Admin"
        let password = "admin"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        print(base64LoginString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        print(encoded)

       URLSession.shared.dataTask(with: request) { data, response, error in
           if let data = data {
               if let response = try? JSONDecoder().decode(Job.self, from: data) {
                   DispatchQueue.main.async {
                       _ = response
                   }
                   return
               }
           }
           
           
       }.resume()
        
    }
    
    
    
}




