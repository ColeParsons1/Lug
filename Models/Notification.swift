//
//  Notification.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/11/22.
//

import Foundation

struct Notification: Codable, Hashable, Identifiable {
    let id: Int
    let job: Int
    let sender: String
    let receiver: String
    let msg: String
    let created_at: String
}
