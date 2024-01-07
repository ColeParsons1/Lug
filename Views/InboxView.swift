//
//  InboxView.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/10/22.
//

import Foundation
import SwiftUI
import UIKit

struct InboxView : View {
    @State var messages = [Message]();
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                List(messages, id: \.id) {item in
                    Text("\(item.msg_content)")
                        .font(.system(size: 28.0, weight: .light))
                        .foregroundColor(Color.primary)
                    Spacer()
                }
            }.onAppear(perform: loadInbox).navigationTitle("Inbox")
            
        }.onAppear(perform: loadInbox)
    }
    
    func loadInbox() {
        guard let url = URL(string: "http://146.190.222.176:8000/messages/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Message].self, from: data) {
                    DispatchQueue.main.async {
                        self.messages = response
                    }
                    return
                }
            }
            
        }.resume()
        
    }
}
