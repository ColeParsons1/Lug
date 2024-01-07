//
//  ViewController.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/7/22.
//

import Foundation
import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import CoreLocation
import MapKit

 
class ViewController: UIViewController {

    var latitude_pickup: Float?
    var longitude_pickup: Float?
    var latitude_destination: Float?
    var longitude_destination: Float?
    var pickup_address: String?
    var destination_address: String?
    
override func viewDidLoad() {
super.viewDidLoad()
    let lat_pickup = Double(latitude_pickup!)
    let lon_pickup = Double(longitude_pickup!)
    let lat_destination = Double(latitude_destination!)
    let lon_destination = Double(longitude_destination!)
    let p_address = ("Pickup" + " (" + pickup_address! + ")")
    let d_address = ("Destination" + " (" + destination_address! + ")")
    
    NavigationMapView.appearance().tintColor = UIColor.systemBlue

    let routeOptions = NavigationRouteOptions(waypoints: [
        Waypoint(coordinate: CLLocationCoordinate2D(latitude: 35.33379919878698, longitude: -80.71131253186213)),
        Waypoint(coordinate: CLLocationCoordinate2D(latitude: lat_pickup, longitude: lon_pickup), name: p_address),
        Waypoint(coordinate: CLLocationCoordinate2D(latitude: lat_destination, longitude: lon_destination), name: d_address),
    ])

    Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
        switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
            guard let self = self else { return
        }
            let viewController = NavigationViewController(for: response, routeIndex: 0, routeOptions: routeOptions)
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
        }
        
        
        
        
    }
    
   
    
}
    
    
}
