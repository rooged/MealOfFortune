//
//  MapView.swift
//  MealOfFortune
//
//  Created by Adam Kenvin on 2/12/21.
//


import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    let mapView = MKMapView()
    @Binding var lat: Double
    @Binding var lon: Double
    @ObservedObject var locationManager = LocationManager()
    var LAT: Double { return locationManager.lastLocation?.coordinate.latitude ?? 0 }
    var LON: Double { return locationManager.lastLocation?.coordinate.longitude ?? 0 }
    @Binding var currentLocation: Bool
    @Binding var removedPin: Bool
    

    // creates UIView because swiftUI Map does not support all needed features
    // sets up gestures for map as well as user location
    func makeUIView(context: Context) -> MKMapView {
        
        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addPin(sender:)))
        let singleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.removePin(sender:)))
        longPress.minimumPressDuration = 0.75 
        mapView.addGestureRecognizer(longPress)
        mapView.addGestureRecognizer(singleTap)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.tintColor = UIColor.blue
        return mapView
    }
    
    // specifies how UIview should be displayed. Span is the zoom of teh map, region is the location it shows
    func updateUIView(_ view: MKMapView, context: Context) {
        var coordinate = CLLocationCoordinate2D(latitude: LAT, longitude: LON)
        if (currentLocation) { coordinate = centerCoordinate }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        //handles adding a pin to the map using a long press (tap and hold) and setting this location to be the lat and lon searched around
        @objc func addPin(sender: UILongPressGestureRecognizer){ // call with long press gesture recognizer
            parent.removedPin = false
            let point = sender.location(in: parent.mapView)
            let loc = parent.mapView.convert(point, toCoordinateFrom: parent.mapView)
            parent.lat = loc.latitude
            parent.lon = loc.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc
            annotation.title = "Dropped pin"
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.addAnnotation(annotation)
            parent.centerCoordinate = CLLocationCoordinate2D(
                latitude: loc.latitude,
                longitude:loc.longitude
            )
           parent.currentLocation = true
        }
        
        // remove teh set pin from the map, reset lat and lon so that you search by user location 
        @objc func removePin(sender: UITapGestureRecognizer){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.lat = 0.0
            parent.lon = 0.0
            parent.removedPin = true
        }
        
    }
    
    
}
