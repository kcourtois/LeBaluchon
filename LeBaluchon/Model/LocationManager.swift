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

enum LocationStatus {
    case loading, noAccess, done
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static var shared = LocationManager()
    private var locationManager = CLLocationManager()
    private(set) var coordinates: Coordinates?

    var canAccessLocation: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            return false
        default:
            return true
        }
    }

    private func postNotification(coordinates: Coordinates) {
        NotificationCenter.default.post(name: .didFoundLocation, object: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = manager.location else {
            return
        }
        let coord = Coordinates(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        self.coordinates = coord
        manager.stopUpdatingLocation()
        postNotification(coordinates: coord)
    }

    func canGetLocation() -> LocationStatus {
        locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted, .notDetermined:
            return .noAccess
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()

            //Checks if coordinates are loaded
            if coordinates == nil {
                return .loading
            } else {
                return .done
            }
        @unknown default:
            return .noAccess
        }
    }
}
