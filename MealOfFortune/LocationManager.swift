//
//  LocationManager.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import Foundation
import CoreLocation
import Combine

//pulls user location upon app launching then stops and only pulls again once user location is changed
class LocationManager: NSObject, ObservableObject {

    //initialize values, ask user for permission to get location, begin pulling location
    override init() {
        super.init()
        self.locationManager.delegate = self
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest //waste of resources
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    //globally accessible variable for last known location
    @Published var lastLocation: CLLocation? { willSet { objectWillChange.send() } }
    let objectWillChange = PassthroughSubject<Void, Never>()
    private let locationManager = CLLocationManager()
}

//pulls user location then stops once location is received as per Apple standards to conserve resources
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        self.locationManager.stopUpdatingLocation()
    }
}
