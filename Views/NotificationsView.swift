//
//  NotificationsView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/10/22.
//

import Foundation
import SwiftUI
import UIKit

struct NotificationsView : View {
    
    @State var notification = [Notification]();
    
    var body: some View {
        NavigationView{
            ZStack{
                List(notification, id: \.id) {item in
                    Text("\(item.id)")
                        .font(.system(size: 28.0, weight: .light))
                        .foregroundColor(Color.primary)
                    Spacer()
                }
            }.onAppear(perform: loadNotifications).navigationTitle("Alerts")
            
        }.onAppear(perform: loadNotifications)
    }
    
    func loadNotifications() {
        guard let url = URL(string: "http://146.190.222.176:8000/notifications/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Notification].self, from: data) {
                    DispatchQueue.main.async {
                        self.notification = response
                    }
                    return
                }
            }
            
        }.resume()
        
    }
}
