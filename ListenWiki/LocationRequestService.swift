//
//  LocationRequestService.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 31/03/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit
import MapKit

struct LocationRequestService  {
    static func requestAuthorisationIfReqd(withManagerObj locationManager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
            print("authorised location access")
        case .denied,.restricted:
            print("denied/restricted location access")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
