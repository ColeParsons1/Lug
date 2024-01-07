//
//  MyJobsView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/3/22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

struct MyJobsView : View {
    
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    
    @State var jobs = [Job]();
    @State var showDetail: Bool = false
    @State var userLocation: String = ""
    @State var showSettings: Bool = false
    @State var isOpenView: Bool = false
    @State var isOpenNav: Bool = false


    var body: some View {
        NavigationView{
                    ZStack{
                            List(jobs, id: \.id) {item in
                                VStack() {
                                    HStack{
                                        Text("\(item.Business_Name)")
                                            .font(.system(size: 32.0, weight: .light))
                                            .foregroundColor(Color.primary)
                                            .frame(maxWidth:.infinity, alignment: .leading)
                                        Image(systemName: "calendar.badge.clock")
                                            .font(.system(size: 16.0, weight: .regular))
                                            .foregroundColor(Color.secondary)
                                            .frame(alignment: .trailing)
                                            .padding(0)
                                        Text("In 3 hrs")
                                            .font(.system(size: 16.0, weight: .regular))
                                            .foregroundColor(Color.secondary)
                                            .frame(alignment: .trailing)
                                            .multilineTextAlignment(.trailing)
                                    }.padding(.top, 16.0).frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                                    HStack{
                                        VStack(spacing: 0){
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
                                            //let coord = $userLocation.coordinate
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
                                            }.frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all).padding(0)
                                            
                                            Text("")
                                                .foregroundColor(Color(hex: 0xfc6022).opacity(0.89))
                                                .font(.system(size: 14.0))
                                                .padding(0)
                                                .frame(maxWidth:.infinity)
                                                .contentShape(Rectangle())
                                                .edgesIgnoringSafeArea(.all)
                                                .onTapGesture {
                                                    //acceptJob(job: item)
                                                    //self.selectedJob = item
                                                    self.showDetail = true
                                                    print(item.id)
                                                } .id(UUID())
                                                .background(NavigationLink(destination: JobDetailView(item: item)) {
                                                    EmptyView()
                                                }.frame(maxWidth:.infinity).padding(0)
                                                    .opacity(0))
                                            
                                            
                                            //.frame(width:302.0, height:300).cornerRadius(2).padding(.bottom, 20.0)
                                        }.frame(maxWidth: .infinity, maxHeight: .infinity).edgesIgnoringSafeArea(.all).padding(0)
                                        
                                    }.frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all).padding(0)//.id(UUID())
                                    MapView(latitude_pickup:item.Latitude_Pickup, longitude_pickup:item.Longitude_Pickup, latitude_destination: item.Latitude_Destination, longitude_destination: item.Longitude_Destination, pickup_address: item.Pickup_Address, destination_address: item.Destination_Address).frame(width:.infinity, height:400).edgesIgnoringSafeArea(.all).cornerRadius(0).padding(.leading, 0).padding(.trailing, 0).padding(.top, -6).padding(.bottom, -3.5)
                                }.listRowSeparator(.hidden).frame(maxWidth: .infinity, maxHeight: .infinity).edgesIgnoringSafeArea(.all).padding(0)//.id(UUID())
                            .foregroundColor(Color(hex: 0xfc6022).opacity(0.89))
                            .edgesIgnoringSafeArea(.all)
                                    //.cornerRadius(4)
                                    //.padding(.top, 0)
                            //}//.navigationViewStyle(StackNavigationViewStyle())
                            
                            
                        }.frame(maxWidth: .infinity).padding(0)//.edgesIgnoringSafeArea(.all)//.background(Color.clear)
                    .navigationBarTitleDisplayMode(.inline)
                        .refreshable {
                            do{
                                self.loadMyJobs()
                            }
                                
                            }.padding(.top, 0).padding(.bottom, 0)//.zIndex(100.0)
                        
                        
            }
                    
                    
                //.edgesIgnoringSafeArea([.leading, .trailing, .top, .bottom])
        }.navigationBarTitleDisplayMode(.inline).navigationTitle("Jobs").foregroundColor(Color.secondary).opacity(1.0)
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadMyJobs)
        .listStyle(PlainListStyle())
        .listSectionSeparator(Visibility.hidden)
        .listRowSeparatorTint(Color(hex: 0xfc6022).opacity(0.0))
        
        
}



func acceptJob(job: Job) {
    guard let url = URL(string: "http://192.168.1.5:8000/acceptjob/?q=\(job.id)/") else {
        print("api is down")
        return
    }
    
    let jobData = Job(id: job.id, Business_Name: job.Business_Name, Job_Type: job.Job_Type, Load_Weight: job.Load_Weight, Description: job.Description, Pieces: job.Pieces, ImageString: "", Image: "", Pickup_Address: job.Pickup_Address, Destination_Address: job.Destination_Address, Date_Needed: job.Date_Needed, Tip: job.Tip, Price: job.Price, Latitude_Pickup: job.Latitude_Pickup, Longitude_Pickup: job.Longitude_Pickup, Latitude_Destination: job.Latitude_Destination, Longitude_Destination: job.Longitude_Destination, Distance: job.Distance, Created: job.Created, InProgress: true, Complete: false, Assigned_Lugger: job.Assigned_Lugger)
   
   guard let encoded = try? JSONEncoder().encode(jobData) else {
               print("Failed to encode order")
               return
           }

   let username = "Cole"
   let password = "colecolecole"
   let loginString = String(format: "%@:%@", username, password)
   let loginData = loginString.data(using: String.Encoding.utf8)!
   let base64LoginString = loginData.base64EncodedString()
   var request = URLRequest(url: url)
   request.httpMethod = "POST"
   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
   request.addValue("application/json", forHTTPHeaderField: "Accept")
   //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
   //request.setValue("X-Api-Key: CoVc2BOz", forHTTPHeaderField: "Authorization")//
   request.httpBody = encoded

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


    
    
 
    func loadMyJobs() {
        guard let url = URL(string: "http://192.168.1.5:8000/myjobs/") else {
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
    
    
    
    
    
}
