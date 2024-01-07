//
//  User.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/10/22.
//

import Foundation

struct User: Codable, Hashable, Identifiable {
    let id: Int
    let first_name: String
    let last_name: String
    let username: String
    let password: String
    let password2: String
    let email: String
}
