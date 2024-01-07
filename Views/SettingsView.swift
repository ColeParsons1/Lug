//
//  SettingsView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/2/22.
//

import SwiftUI
import Foundation
import UIKit

struct SettingsView : View {
    @Environment(\.presentationMode) var presentationMode
    //var function: () -> Void
    @State var topic: String = ""
    @State var author: String = ""
    @State var content: String = ""
    @State var created: String = ""
    @State var image: String = ""
    @State var fileName: String = ""
    //@State var p: [Profile](); = nil
    //@State var string = CGSize() as String
    @State var author_profile_picture: String = ""
    @State var author_display_name: String = ""
    @State private var isShowPhotoLibrary = false
    @State private var i = UIImage()
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    HStack{
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        
                        TextField("", text: $content)
                            .foregroundColor(Color(hex: 0x81909e))
                            .font(.system(size: 16))
                    }.ignoresSafeArea(.keyboard, edges: .bottom)
                        .padding(0)
                        .opacity(1.0)
                    HStack {
                        Button(action: {
                            self.isShowPhotoLibrary = true
                        }){
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                .opacity(1.0)
                            
                            
                        }
                        .padding(0)
                        .edgesIgnoringSafeArea(.all)
                    }
                    .sheet(isPresented: $isShowPhotoLibrary) {
                       // ImagePicker(sourceType: .photoLibrary, selectedImage: self.$i)
                    }
                    Image(uiImage: self.i)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    HStack{
                        Image(systemName: "eye")
                            .font(.system(size: 15))
                            .foregroundColor(Color.blue)
                        
                        Text("Who can see this post?")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 12))
                        //.font(.headline)
                    }.opacity(1.0)
                    
                    Button(action: {
                    }, label: {
                        Text("Send")
                            .font(.system(size: 16))
                    })
                }
                .zIndex(-1000.0)
                .background(Color.clear)
                
                
            }.edgesIgnoringSafeArea([.leading, .trailing]).background(Color.clear)
                .listStyle(PlainListStyle()).background(Color.clear)
                .padding(0)
                .navigationBarTitle(Text("New Post"), displayMode: .inline).font(.system(size: 20.0))
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.font(.system(size: 16))
                    )//self.postPost() //self.uploadImage(image:i)
        }
        
        //.background()//.sheet(isPresented: $isShowPhotoLibrary) {
        //ImagePicker(sourceType: .photoLibrary)
        // }
    }
    
    func loadProfile() {
        guard let url = URL(string: "http://192.168.1.6:8000/profiles/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic YWRtaW46dGVzdDEyMzQ1", forHTTPHeaderField: "Authorization")
        
       // URLSession.shared.dataTask(with: request) { data, response, error in
            //if let data = data {
                //if let response = try? JSONDecoder().decode([Profile].self, from: data) {
                   // DispatchQueue.main.async {
                        //self.profiles = response
                    //}
                    //return
                //}
            }
            
        }//.resume()
         //loadProfileLink()
        
    //}
//}
