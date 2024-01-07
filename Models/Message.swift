//
//  Message.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/11/22.
//

import Foundation

struct Message: Codable, Hashable, Identifiable {
    let id: Int
    let sender: String
    let receiver: String
    let msg_content: String
    let created_at: String
}
