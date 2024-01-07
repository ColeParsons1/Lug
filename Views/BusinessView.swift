//
//  BusinessView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/17/22.
//

import Foundation
import SwiftUI
import Mapbox
import CoreLocation
import UIKit
import AVKit
import Social
import Combine
import MapKit
import MapboxSearch
import MapboxSearchUI

struct BusinessView : View {
    
    
    
    
    //@State var username: String?
    @State var jobs = [Job]();
    @State var showDetail: Bool = false
    @State var userLocation: String = ""
    @State var showSettings: Bool = false
    @State var isOpenView: Bool = false
    @State var isOpenNav: Bool = false
    @State private var selectedJob: Job?
    @Environment(\.presentationMode) var presentationMode
    //var function: () -> Void

    @State var Business_Name: String = ""
    @State var Job_Type: String = ""
    let types = ["General", "Medical", "Construction", "Food"]
    @StateObject private var mapSearch = MapSearch()
    @StateObject private var mapSearch2 = MapSearch2()
    @State var Load_Weight: String = ""
    @State var Description: String = ""
    @State var Pieces: String = ""
    @State var ImageString: String = ""
    @State var Pickup_Date = Date()
    @State var Pickup_Time = Date()
    @State var Pickup_Address: String = ""
    @State var Destination_Address: String = ""
    @State var Date_Needed: String = ""
    @State var Tip: String = ""
    @State var Price: String = ""
    @State var Latitude_Pickup: Float = 0.0
    @State var Longitude_Pickup: Float = 0.0
    @State var Latitude_Destination: Float = 0.0
    @State var Longitude_Destination: Float = 0.0
    @State var Distance:Float = 0.0
    @State var Created: String = ""
    @State var InProgress: Bool = false
    @State var Complete: Bool = false
    @State var Assigned_Lugger: String = ""
    @State var fileName: String = "1"
    @State var author_profile_picture: String = ""
    @State var author_display_name: String = ""
    @State private var isShowPhotoLibrary = false
    @State private var isShowVideoLibrary = false
    @State private var showPickup = true
    @State private var showDestination = true
    @State private var i = UIImage()
      @State private var t : String = ""
    @State var profiles = [Account]();
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var isRegisterView = false
    @State var isJobView = false
    @State var isBusinessView = false
    
    var body: some View {
        TabView{
            NavigationView{
                ZStack{
                List{
                    VStack{
                        TextField("Company Name", text: $Business_Name)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 0)
                            .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                            .foregroundColor(Color.white)
                            .opacity(1.0)
                            .accentColor(.primary)
                            .cornerRadius(8)
                    }
                    VStack{
                            Picker("Job Type", selection: $Job_Type) {
                                ForEach(types, id: \.self) {
                                    Text($0)
                                }
                            }.frame(maxWidth:.infinity)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 0)
                        
                        .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                        .foregroundColor(.secondary)
                        .accentColor(.primary)
                        //.cornerRadius(8)
                        .opacity(0.5)
                        .contentShape(Rectangle())
                    }.frame(maxWidth:.infinity).padding(.leading, 0)
                    VStack{
                        DatePicker("Day Needed", selection: $Pickup_Date, displayedComponents: .date)
                            .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 0)
                            .frame(maxWidth:.infinity)
                    }.frame(maxWidth:.infinity)
                    VStack{
                        DatePicker("Time Needed", selection: $Pickup_Date, displayedComponents: .hourAndMinute)
                            .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 0)
                            .frame(maxWidth:.infinity)
                    }
                        VStack{
                            TextField("Load Weight (lbs)", text: $Load_Weight)
                                .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                                .foregroundColor(Color.white)
                                .accentColor(.primary)
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 0)
                                .opacity(1.0)
                            //Divider().frame(maxWidth:.infinity)
                        }.frame(maxWidth:.infinity).opacity(1.0)
                        VStack{
                            TextField("Pieces", text: $Pieces)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 0)
                                .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                                .foregroundColor(Color.white)
                                .accentColor(.primary)
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                            //Divider().frame(maxWidth:.infinity)
                        }.frame(maxWidth:.infinity)
                        
                        VStack{
                            
                            TextField("Pickup Address", text: $mapSearch.searchTerm)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 0)
                                .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                                .foregroundColor(Color.white)
                                .accentColor(.primary)
                                .cornerRadius(8)
                            //Divider().frame(maxWidth:.infinity)
                        }.frame(maxWidth:.infinity).foregroundColor(Color.white)
                            Section {
                                if showPickup{
                                    ForEach(mapSearch.locationResults, id: \.self) { location in
                                        VStack(alignment: .leading){
                                            Text(location.title)
                                                .multilineTextAlignment(.leading)
                                                .contentShape(Rectangle())
                                                .frame(alignment: .leading)
                                                .onTapGesture{
                                                    self.mapSearch.searchTerm = location.title + " " + location.subtitle
                                                    self.Pickup_Address = location.title + " " + location.subtitle
                                                    self.showPickup.toggle()
                                                }
                                            Text(location.subtitle)
                                                .multilineTextAlignment(.leading)
                                                .font(.system(.caption))
                                                .padding(.bottom, 3.0)
                                                .frame(alignment: .leading)
                                        }
                                    }.frame(alignment: .leading).multilineTextAlignment(.leading)
                                //}
                                            }
                                    
                        VStack{
                            TextField("Destination Address", text: $mapSearch2.searchTerm)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 0)
                                .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                                .foregroundColor(Color.white)
                                .accentColor(.primary)
                                .cornerRadius(8)
                            //Divider().frame(maxWidth:.infinity)
                        }
                        Section {
                            if showDestination{
                                ForEach(mapSearch2.locationResults, id: \.self) { location in
                                    VStack(alignment: .leading){
                                        Text(location.title)
                                            .multilineTextAlignment(.leading)
                                            .contentShape(Rectangle())
                                            .frame(alignment: .leading)
                                            .onTapGesture{
                                                self.mapSearch2.searchTerm = location.title + " " + location.subtitle
                                                self.Destination_Address = location.title + " " + location.subtitle
                                                self.showDestination.toggle()
                                            }
                                        Text(location.subtitle)
                                            .multilineTextAlignment(.leading)
                                            .font(.system(.caption))
                                            .padding(.bottom, 3.0)
                                            .frame(alignment: .leading)
                                    }
                                }.frame(alignment: .leading).multilineTextAlignment(.leading)
                            }
                        }.frame(alignment: .leading).edgesIgnoringSafeArea(.all).multilineTextAlignment(.leading)
                        VStack{
                            TextField("Delivery Instructions", text: $Description)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 0)
                                .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                                .foregroundColor(Color.white)
                                .accentColor(.primary)
                                .cornerRadius(8)
                            //Divider().frame(maxWidth:.infinity)
                        }
                        VStack{
                            TextField("Tip", text: $Tip)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 0)
                                .background(Color.clear)//.background(Color(hex: 0xBEC3C6))
                                .foregroundColor(Color.white)
                                .accentColor(.primary)
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }.foregroundColor(Color.white)
                             
                        }.ignoresSafeArea(.keyboard, edges: .bottom)
                        .padding(0)
                        .opacity(1.0)
                    
                            HStack {
                                Button(action: {
                                    self.isShowPhotoLibrary.toggle()
                                                self.t = "img"
                                             fileName = randomString(length: 10) + ".png"
                                }){
                                                Image(systemName: "photo")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.secondary)
                                                    .opacity(0.8)
                             

                                            }
                                            .padding(0)
                                            .edgesIgnoringSafeArea(.all)
                        }.sheet(isPresented: $isShowPhotoLibrary) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$i, type: self.$t)
                            
          }
                    Image(uiImage: self.i)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .edgesIgnoringSafeArea(.all)

                }.navigationBarTitle(Text("New Job"), displayMode: .inline).font(.system(size: 20.0)).foregroundColor(Color(hex: 0xfc6022))
                        .navigationBarItems(//trailing: Button(action:{self.postJob(image: self.i, fileName: self.fileName)}, label: {
                            trailing: Button(action:{self.upload(paramName: "test", fileName: self.fileName, image: self.i, isImage: self.isShowVideoLibrary)}, label: {
                                Text("Send") //self.upload(paramName: "test", fileName: self.fileName, image: self.i, isImage: self.isShowVideoLibrary)
                                      .font(.system(size: 16))//self.uploadImage(image: i)
                            }))//.background(Color.clear).accentColor(Color(hex: 0xfc6022))
                .accentColor(Color(hex: 0xfc6022)).edgesIgnoringSafeArea([.leading, .trailing, .top, .bottom])//.background(Color.clear)
                .listStyle(PlainListStyle())//.background(Color.white)
                .padding(.top, 20)
                .navigationBarTitle(Text("New Job")).foregroundColor(Color(hex: 0xfc6022))
                
                     
                                
                }
                
                
                
                
                //self.postPost() //self.uploadImage(image:i)
            }
                
            
                 .tabItem {
                     VStack{
                         Image(systemName: "doc.badge.plus").tint(.white)
                         Text("Add Job")
                     }
                  }
            //TestControllerView()
                   AccountView() //AccountView(username: self.username!)
                 .tabItem {
                     VStack{
                         Image(systemName: "doc.plaintext").tint(.white)
                         Text("My Orders")
                         
                     }
                   }.tint(.white)
                   NotificationsView()
                 .tabItem {
                     VStack{
                         Image(systemName: "person.circle").tint(.white)
                         Text("Account")
                     }
                   }.tint(.white)
                   //SettingsView()
                   InboxView()
                 .tabItem {
                     VStack{
                         Image(systemName: "bell").tint(.white)
                         Text("Alerts")
                     }
                   }.tint(.white)
                  //MessageView(function: self.loadProfile)
                   MyJobsView()
                 .tabItem {
                     VStack{
                         Image(systemName: "envelope").tint(.white)
                         Text("Inbox")
                     }
                   }.tint(.white)
        }.accentColor(Color(hex: 0xfc6022).opacity(0.89)).background(Color.clear)
            .navigationBarBackButtonHidden(true)
            .background(Color.clear).navigationBarBackButtonHidden(true)
            
    }
    
    
    
    
 
    func sendURL(image: UIImage, fileName: String) {
        
        Business_Name = self.Business_Name.replacingOccurrences(of: " ", with: "_")
        Pickup_Address = self.Pickup_Address.replacingOccurrences(of: " ", with: "_")
        Destination_Address = self.Destination_Address.replacingOccurrences(of: " ", with: "_")
        Description = self.Description.replacingOccurrences(of: " ", with: "_")
        //Date_Needed = self.Pickup_Date.replacingOccurrences(of: " ", with: "_")
        
        if fileName != "1"{
            guard let url = URL(string: "http://192.168.1.5:8000/add/?BusinessName=\(Business_Name)&JobType=\(self.Job_Type)&LoadWeight=\(self.Load_Weight)&ImageString=\(fileName ?? "1.nil")&Image=\(fileName ?? "1.nil")&Description=\(Description)&Pieces=\(self.Pieces)&PickupAddress=\(Pickup_Address)&DestinationAddress=\(Destination_Address)&Tip=\(Float(self.Tip) ?? 0.0)") else {
                print("api is down")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
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
        
        if fileName == "1"{
            
            guard let url = URL(string: "http://192.168.1.5:8000/add/?BusinessName=\(Business_Name)&JobType=\(self.Job_Type)&LoadWeight=\(self.Load_Weight)&ImageString=\("1.nil")&Image=\("1.nil")&Description=\(Description)&Pieces=\(self.Pieces)&PickupAddress=\(Pickup_Address)&DestinationAddress=\(Destination_Address)&Tip=\(Float(self.Tip) ?? 0.0)") else {
                print("api is down")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
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
            
            
            
        
        

        //request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        
        
    }
    
     func postJob(image: UIImage, fileName: String) {
         
         guard let url = URL(string: "http://192.168.1.5:8000/jobs/") else {
             print("api is down")
             return
         }
          
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          //request.addValue("X-Api-Key: CoVc2BOz.pbkdf2_5Fsha256_24320000_24bszKAb7hsgPA6MTwCGSw8i_24nVDeZS5ITIx7YCLTidO2J9j7yNIhlgUWTSvuOqLEcRU_3D", forHTTPHeaderField: "Api-Key")
         //request.addValue("Basic YWRtaW46dGVzdDEyMzQ1", forHTTPHeaderField: "Authorization")
     getBase64Image(image: image) { base64Image in
        let boundary = "Boundary-\(UUID().uuidString)"
             if fileName != "1"{
                 let jobData = Job(id: 0, Business_Name: self.Business_Name, Job_Type: self.Job_Type, Load_Weight: Int(self.Load_Weight) ?? 0, Description: self.Description, Pieces: Int(self.Pieces) ?? 0, ImageString: fileName ?? "1.nil", Image: fileName, Pickup_Address: self.Pickup_Address, Destination_Address: self.Destination_Address, Date_Needed: "", Tip: Float(self.Tip) ?? 0, Price: Float(self.Price) ?? 0, Latitude_Pickup: self.Latitude_Pickup, Longitude_Pickup: self.Longitude_Pickup, Latitude_Destination: self.Latitude_Destination, Longitude_Destination: self.Longitude_Destination, Distance: self.Distance, Created: self.Created, InProgress: false, Complete: false, Assigned_Lugger: "")
         
          guard let encoded = try? JSONEncoder().encode(jobData) else {
               print("api is down")
               return
           }
          
          var body = ""
          body += "--\(boundary)\r\n"
          body += "Content-Disposition:form-data; name=\"image\""
          body += "\r\n\r\n\(base64Image ?? "")\r\n"
          body += "--\(boundary)--\r\n"
          let iData = body.data(using: .utf8)
          request.httpBody = iData

          URLSession.shared.dataTask(with: request) { data, response, error in
               if let mimeType = response?.mimeType, mimeType == "application/json", let data = iData, let dataString = String(data: data, encoding: .utf8) {

                                        if let response = try? JSONDecoder().decode(Job.self, from: data) {
                                            DispatchQueue.main.async {
                                                _ = response
                                                //self.function()
                                                presentationMode.wrappedValue.dismiss()

                                            }
                                            return
                                        }
                              
                          }
               else{
                   let jobData = Job(id: 0, Business_Name: self.Business_Name, Job_Type: self.Job_Type, Load_Weight: Int(self.Load_Weight) ?? 0, Description: self.Description, Pieces: Int(self.Pieces) ?? 0, ImageString: fileName ?? "1.nil", Image: fileName, Pickup_Address: self.Pickup_Address, Destination_Address: self.Destination_Address, Date_Needed: "", Tip: Float(self.Tip) ?? 0, Price: Float(self.Price) ?? 0, Latitude_Pickup: self.Latitude_Pickup, Longitude_Pickup: self.Longitude_Pickup, Latitude_Destination: self.Latitude_Destination, Longitude_Destination: self.Longitude_Destination, Distance: self.Distance, Created: self.Created, InProgress: false, Complete: false, Assigned_Lugger: "")
                    
                    guard let encoded = try? JSONEncoder().encode(jobData) else {
                         print("api is down")
                         return
                     }

                   request.httpBody = encoded
                         
                    if let response = try? JSONDecoder().decode(Job.self, from: data!) {
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
             
             if fileName == "1"{
                 let jobData = Job(id: 0, Business_Name: self.Business_Name, Job_Type: self.Job_Type, Load_Weight: Int(self.Load_Weight) ?? 0, Description: self.Description, Pieces: Int(self.Pieces) ?? 0, ImageString: self.ImageString, Image: fileName, Pickup_Address: self.Pickup_Address, Destination_Address: self.Destination_Address, Date_Needed: "", Tip: Float(self.Tip) ?? 0, Price: Float(self.Price) ?? 0, Latitude_Pickup: self.Latitude_Pickup, Longitude_Pickup: self.Longitude_Pickup, Latitude_Destination: self.Latitude_Destination, Longitude_Destination: self.Longitude_Destination, Distance: self.Distance, Created: self.Created, InProgress: false, Complete: false, Assigned_Lugger: "")
            
             guard let encoded = try? JSONEncoder().encode(jobData) else {
                    print("api is down")
                    return
              }
             
             var body = ""
             body += "--\(boundary)\r\n"
             body += "Content-Disposition:form-data; name=\"image\""
             body += "\r\n\r\n\(base64Image ?? "")\r\n"
             body += "--\(boundary)--\r\n"
             let iData = body.data(using: .utf8)
             request.httpBody = encoded

             URLSession.shared.dataTask(with: request) { data, response, error in
                    if let mimeType = response?.mimeType, mimeType == "application/json", let data = iData, let dataString = String(data: data, encoding: .utf8) {

                                                     if let response = try? JSONDecoder().decode(Job.self, from: data) {
                                                          DispatchQueue.main.async {
                                                                _ = response
                                                                //self.function()
                                                                presentationMode.wrappedValue.dismiss()

                                                          }
                                                          return
                                                     }
                                        
                                  }
                                 
                          if let response = try? JSONDecoder().decode(Job.self, from: data!) {
                                            DispatchQueue.main.async {
                                                 _ = response
                                                 //self.function()
                                                 presentationMode.wrappedValue.dismiss()

                                            }
                                            return
                                      }

             }.resume()
                             //}.resume()
             }

     }
         //presentationMode.wrappedValue.dismiss()
        
    }
    
    func uploadImage(image: UIImage) {
        
        
            getBase64Image(image: image) { base64Image in
                let boundary = "Boundary-\(UUID().uuidString)"
                var request = URLRequest(url: URL(string: "http://192.168.1.5:8000/images/")!)
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
                request.addValue("58wgEeCeXMVk6iN2bSmKukfs3UnfSOkXMNEpKKdOPF9PriscLpKhGyWyo7ePCypt", forHTTPHeaderField: "X-CSRFToken")
                request.httpMethod = "POST"
                var body = ""
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"Image\""
                body += "\r\n\r\n\(base64Image ?? "")\r\n"
                body += "--\(boundary)--\r\n"
                let iData = body.data(using: .utf8)
                request.httpBody = iData
                //print(iData)
                
                
                
                URLSession.shared.dataTask(with: request) { iData, response, error in
                                if let error = error {
                                    print("failed with error: \(error)")
                                    return
                                }
                                guard let response = response as? HTTPURLResponse,
                                    (200...299).contains(response.statusCode) else {
                                    print("server error")
                                    return
                                }
                                if let mimeType = response.mimeType, mimeType == "application/json", let data = iData, let dataString = String(data: data, encoding: .utf8) {
                                    print("imgur upload results: \(dataString)")

                                    let parsedResult: [String: AnyObject]
                                    do {
                                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                                        if let dataJson = parsedResult["data"] as? [String: Any] {
                                            print("Link is : \(dataJson["link"] as? String ?? "Link not found")")
                                        }
                                    } catch {
                                        // Display an error
                                    }
                                }
                            }.resume()
            }
        }

        func getBase64Image(image: UIImage, complete: @escaping (String?) -> ()) {
            DispatchQueue.main.async {
                 let imageData = image.pngData()
                 let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
                complete(base64Image)
            }
        }
     
      func upload(paramName: String, fileName: String, image: UIImage, isImage: Bool) {
          if fileName != "1"{
              let url = URL(string: "http://192.168.1.5:8000/video/")
              let boundary = UUID().uuidString
              
              print(fileName)
              
              
              
              let session = URLSession.shared
              
              let imageData = image.pngData()
              let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
              
              let jobData = Images(id: 0, image: base64Image!)
              
              guard let encoded = try? JSONEncoder().encode(jobData) else {
                  print("api is down")
                  return
              }
              
              print(encoded)
              
              // Set the URLRequest to POST and to the specified URL
              var urlRequest = URLRequest(url: url!)
              urlRequest.httpMethod = "POST"
              urlRequest.httpBody = encoded
              
              
              
              // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
              // And the boundary is also set here
              urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
              urlRequest.addValue("zhrfrBBihSOfj5Y5tHH0iRu1qUJlfm7Vamu8IRXt7fHGtboR1sw9fW6KgliMXNSh", forHTTPHeaderField: "X-CSRFToken")
              urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
              //urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
              //urlRequest.setValue("Basic YWRtaW46dGVzdDEyMzQ1", forHTTPHeaderField: "Authorization")
              
              var data = Data()
              
              //let idata = image.pngData()!
              data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
              data.append("Content-Disposition: form-data; name=\"Video\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
              data.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
              //data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
              if imageData != nil{
                  data.append((imageData)!)
              }
              
              data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
              
              
              session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                  if error == nil {
                      let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                      if let json = jsonData as? [String: Any] {
                          print(json)
                      }
                  }
              }).resume()
              sendURL(image: self.i, fileName: fileName)
          }
          if fileName == "1"{
              sendURL(image: self.i, fileName: fileName)
          }
     }
    
     
     func randomString(length: Int) -> String {
       let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
       return String((0..<length).map{ _ in letters.randomElement()! })
     }
    
}






