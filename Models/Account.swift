//
//  Account.swift
//  Root
//
//  Created by Cole Parsons on 10/26/22.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    let id: Int
    let user: String
    let location: String
    let Profile_Picture: String
    let Account_Type: Int
}
