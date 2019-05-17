//
//  LocationManager.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 13/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static var shared = LocationManager()
    private var locationManager = CLLocationManager()
    private(set) var coordinates: Coordinates?

    private override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = manager.location else {
            return
        }
        self.coordinates = Coordinates(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        manager.stopUpdatingLocation()
    }
}
