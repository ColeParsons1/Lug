//
//  Job.swift
//  Root
//
//  Created by Cole Parsons on 10/26/22.
//

import Foundation

struct Job: Codable, Hashable, Identifiable {
    let id: Int
    var Business_Name: String
    var Job_Type: String
    var Load_Weight: Int
    var Description: String
    var Pieces: Int
    var ImageString: String
    var Image: String
    var Pickup_Address: String
    var Destination_Address: String
    var Date_Needed: String
    var Tip: Float
    var Price: Float
    var Latitude_Pickup: Float
    var Longitude_Pickup: Float
    var Latitude_Destination: Float
    var Longitude_Destination: Float
    var Distance: Float
    var Created: String
    var InProgress: Bool
    var Complete: Bool
    var Assigned_Lugger: String?
    
    //var Company: String
    //var Company_Profile: Int?
    //var Company_Profile_Picture: String
    //var Company_Verified: Bool
}
