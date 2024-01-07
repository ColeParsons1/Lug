//
//  NewMapView.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/10/22.
//

import Foundation
import UIKit
import SwiftUI
import MapKit
import AVFoundation
import CoreLocation

class PointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}

struct NewMapView: UIViewRepresentable {
   
    @State private var directions: [String] = []
    @State var jobs = [Job]();
    @State var mapView = MKMapView()
    @State private var showDirections = false
    @State var locationManager: CLLocationManager
    
    var latitude_pickup: Float?
    var longitude_pickup: Float?
    var latitude_destination: Float?
    var longitude_destination: Float?
    var pickup_address: String?
    var destination_address: String?
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor(Color(hex: 0xfc6022).opacity(0.89))
         renderer.lineWidth = 6.5
          return renderer
        }
      }
 
 class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
 init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
       self.title = title
       self.locationName = locationName
       self.coordinate = coordinate
    }
 }
    
  typealias UIViewType = MKMapView
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
      }
 
 
  
    func makeUIView(context: Context) -> MKMapView {
        self.mapView = MKMapView()
        mapView.delegate = context.coordinator
        loadJobFeed()
     
     
      
      
      

     
     

        
            
            
            //mapView.modalPresentationStyle = .fullScreen
                //self.present(MapView, animated: true, completion: nil)
            
        
      return mapView
  }
    
    func loadJobFeed() { //146.190.222.176:8000
        let url = URL(string: "http://192.168.1.5:8000/jobs/")
        
        var req = URLRequest(url: url!)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        req.addValue("58wgEeCeXMVk6iN2bSmKukfs3UnfSOkXMNEpKKdOPF9PriscLpKhGyWyo7ePCypt", forHTTPHeaderField: "X-CSRFToken")
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        self.jobs = response
                        for item in jobs {
                            //self.mapView = MKMapView()
                            let lat_pickup = Double(item.Latitude_Pickup)
                            let lon_pickup = Double(item.Longitude_Pickup)

                            
                            print(lat_pickup)
                            print(lon_pickup)
                            
                            let locValue:CLLocationCoordinate2D = self.locationManager.location!.coordinate
                            print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")

                            let coordinate = CLLocationCoordinate2D(
                                latitude: locValue.latitude, longitude: locValue.longitude)
                            let span = MKCoordinateSpan(latitudeDelta: 12.0, longitudeDelta: 12.0)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            
                            //let region = MKCoordinateRegion(
                                //center: CLLocationCoordinate2D(latitude: lat_pickup, longitude: lon_pickup),
                                //span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                            mapView.setRegion(region, animated: true)
                            
                            
                            
                            let pin1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat_pickup, longitude: lon_pickup))
                            let pin2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude))
                            
                            let p1 = MapPin(title: item.Business_Name, locationName: item.Pickup_Address, coordinate: CLLocationCoordinate2D(latitude: lat_pickup, longitude: lon_pickup))
                                Button {
                                    //selectedDestination = result result == selectedDestination ?
                                } label: {
                                    Image(systemName: "mappin.circle")
                                }
                            
                            let annotationView = MKMarkerAnnotationView(annotation: p1, reuseIdentifier: "pin")
                            annotationView.tintColor = UIColor(Color(hex: 0xfc6022).opacity(0.89))
                            //p1.color = UIColor(Color(hex: 0xfc6022).opacity(0.89))
                            
                            
                            
                            //let mapRect = MKMapRectMake(fmin(pin1.x,pin1.x));
                            //let rects = pin1.lazy.map { MKMapRect(origin: MKMapPoint($0), size: MKMapSize()) }
                            //let fittingRect = rects.reduce(MKMapRect.null) { $0.union($1) }
                            let request = MKDirections.Request()
                            request.source = MKMapItem(placemark: pin1)
                            request.destination = MKMapItem(placemark: pin2)
                            //request.transportType = .automobile
                            //let rect = makeRect(coordinates: lat_pickup, lon_pickup)
                            let directions = MKDirections(request: request)
                            directions.calculate { response, error in
                            guard let route = response?.routes.first else { return }
                            mapView.addAnnotations([p1])
                            mapView.isScrollEnabled = true
                            mapView.isUserInteractionEnabled = true
                            mapView.tintAdjustmentMode = .normal
                            mapView.tintColor = UIColor(Color(hex: 0xfc6022).opacity(0.89))
                            mapView.showsUserLocation = true
                            mapView.setVisibleMapRect(
                                    route.polyline.boundingMapRect,
                                    edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),
                                    animated: true)
                            //mapView.setCenter(CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude), animated: true)
                                
                                //return
                                
                            }
                            //return
                            
                            
                        }
                        //return
                    }//.resume()
                    
                }//.resume()
                
            }//.resume()
            
        }.resume()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locations.last.map {
                let location = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                )
            }
        }
    
    
 
 

  func updateUIView(_ uiView: MKMapView, context: Context) {
   
      
      
      
  }
}


struct AnnotatedMapView: View {
    
    //@ObservedObject
    @State var showDetail: Bool = false
    @State var item: Job
    // Default to center on the UK, zoom to show the whole island
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 54.4609,
                                       longitude: -3.0886),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    //@ObservedObject var store: ClubStore
    
    var body: some View {
        ZStack {
            Text("")
                .padding(0)
                .frame(maxWidth:.infinity)
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    self.showDetail.toggle()
                                }).id(UUID())
                .background(NavigationLink(destination: JobDetailView(item: item)) {
                    EmptyView()
                }.frame(maxWidth:.infinity).padding(0)
                    .opacity(0))
            .edgesIgnoringSafeArea(.bottom)
        }
        
        
    }
}

