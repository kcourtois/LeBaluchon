//
//  LocationManager.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 13/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private(set) var coordinates: CLLocationCoordinate2D?

    override init() {
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
        self.coordinates = loc.coordinate
        manager.stopUpdatingLocation()
    }
}
