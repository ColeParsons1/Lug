//
//  NewJobFeedView.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/12/22.
//

import Foundation
import SwiftUI
import UIKit
import CoreLocation
import MapKit
import SwiftUICalendar


struct NewJobFeedView : View {
    
    init(){
            let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.shadowImage = UIImage()
                navBarAppearance.shadowColor = UIColor.black
                navBarAppearance.backgroundColor = UIColor.black
                navBarAppearance.titleTextAttributes = [.foregroundColor : UIColor(Color.primary.opacity(1.0))]
                navBarAppearance.configureWithTransparentBackground()
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
                UINavigationBar.appearance().standardAppearance = navBarAppearance
                UINavigationBar.appearance().compactAppearance = navBarAppearance
                UINavigationBar.appearance().isOpaque = false
                UINavigationBar.appearance().isTranslucent = true
                UINavigationBar.appearance().prefersLargeTitles = false
        let tabBarAppearance = UITabBarAppearance()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
            //tabBarAppearance.configureWithTransparentBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            //UITabBar.appearance().barTintColor = UIColor(Color(hex: 0x000000).opacity(1.0))
            UITabBar.appearance().isOpaque = true
            //UITabBar.appearance().backgroundColor = UIColor(Color(hex: 0x000000).opacity(1.0))
            UITabBar.appearance().isTranslucent = true
            //UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    @State var jobs = [Job]();
    @State var i : Job?
    @State var showDetail: Bool = false
    @State var userLocation: String = ""
    @State var selection: String = ""
    @State var showSettings: Bool = false
    @State var isOpenView: Bool = false
    @State var isOpenNav: Bool = false
    @State var locationManager = CLLocationManager()
    @State var delay: Double = 0 // 1.
    @State var scale: CGFloat = 0.5
    @StateObject private var regionWrapper = RegionWrapper()
    let types = ["New Jobs", "My Jobs"]
    @State private var selectedJob: Job?
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.333282470703125, longitude: -80.71142169527074), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    //@State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.333282470703125, longitude: -80.71142169527074), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        TabView{
            NavigationView{
                ZStack{
                    Map(coordinateRegion: regionWrapper.region, interactionModes: .all, showsUserLocation: true,
                        annotationItems: jobs) { item in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(item.Latitude_Pickup), longitude: Double(item.Longitude_Pickup))){
                            Circle()
                                .foregroundColor(Color(hex: 0xfc6022))
                                .frame(width: 38, height: 38)
                                .id(UUID())
                                .contentShape(Rectangle())
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 2.5).repeatForever().delay(delay))
                                .onAppear{
                                    withAnimation {
                                        self.scale = 1.0
                                    }
                                }.highPriorityGesture(
                                        TapGesture()
                                            .onEnded { _ in
                                                self.i = item
                                                self.showDetail.toggle()
                                            })
                                .onTapGesture {
                                    self.i = item
                                    showDetail.toggle()
                                }.sheet(item: $i) { it in
                                    JobDetailView(item: it)
                                }.onDisappear{
                                    showDetail = false
                                }
                                //.strokeBorder(Color(hex: 0xfc6022).opacity(0.89), lineWidth: 4)
                        }
                        
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity).padding(0)//.edgesIgnoringSafeArea(.all)//.background(Color.clear)
                        .navigationBarTitleDisplayMode(.inline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)//.padding(.top, 0).padding(.bottom, 84.0).padding(.leading, 0).padding(.trailing, 0)//.zIndex(100.0)//.edgesIgnoringSafeArea(.all)
                        .listRowSeparatorTint(Color(hex: 0x000000).opacity(1.0))
                }.frame(maxWidth: .infinity).padding(0)//.edgesIgnoringSafeArea(.all)//.overlay(Divider()
                    //.frame(width: .infinity, height: 0.001)
                    //.background(Color(hex: 0x080808)), alignment: .bottom)
                
                
                    .edgesIgnoringSafeArea([.top]).frame(maxWidth:.infinity).padding(.leading, 0).padding(.trailing, 0)
            }
            
            //.navigationBarTitleDisplayMode(.inline)//.navigationBarBackButtonHidden(true).foregroundColor(Color.secondary).opacity(1.0)
            
            
            .tabItem {
                VStack{
                    Image(systemName: "scroll")
                    Text("Jobs")
                }
            }
            //TestControllerView()
            //AccountView() //AccountView(username: self.username!)
            MyJobsView()
                .tabItem {
                    VStack{
                        Image(systemName: "doc.plaintext.fill").tint(.black)
                        Text("My Jobs")
                    }
                }.tint(.black)
            //CalendarView(ascVisits: JobDate.mocks(
                //start: .daysFromToday(days: -30*36),
                //end: .daysFromToday(days: 30*36)),
                         //initialMonth: Date())
            //CalendarView() { date in
                //Text("\(date.day)")
            //}
            //SelectionView()
            AccountView()
            .tabItem {
                VStack{
                    Image(systemName: "person.circle").tint(.black)
                    Text("Account")
                }
            }.tint(.black)
            //SettingsView()
            InboxView()
                .tabItem {
                    VStack{
                        Image(systemName: "bell").tint(.black)
                        Text("Alerts")
                    }
                }.tint(.black)
            //MessageView(function: self.loadProfile)
            MyJobsView()
                .tabItem {
                    VStack{
                        Image(systemName: "envelope").tint(.black)
                        Text("Inbox")
                    }
                }.tint(.black)
        }.accentColor(Color(hex: 0xfc6022)).navigationBarBackButtonHidden(true).navigationTitle("Lug").foregroundColor(Color.black).onAppear(perform: loadJobFeed)
    }
                
            
    
    
    
    
    
 
    func loadJobFeed() { //146.190.222.176:8000
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
                    }
                    return
                }
            }
            
        }.resume()
        
    }
    
    func updateRegion(newRegion: MKCoordinateRegion) {
            withAnimation {
                regionWrapper.region.wrappedValue = newRegion
                regionWrapper.flag.toggle()
            }
        }
    
    
}


class RegionWrapper: ObservableObject {
    
    //let locValue:CLLocationCoordinate2D = NewJobFeedView.locationManager.location!.coordinate
    var _region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.333282470703125, longitude: -80.71142169527074),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

    var region: Binding<MKCoordinateRegion> {
        Binding(
            get: { self._region },
            set: { self._region = $0 }
        )
    }

    @Published var flag = false
}
