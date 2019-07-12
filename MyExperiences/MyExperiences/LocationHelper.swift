//
//  LocationHelper.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import Foundation
import MapKit

class LocationHelper {

    let locationManager = CLLocationManager()

    func requestAuth() {
        locationManager.requestWhenInUseAuthorization()
    }

    func currentLocation() {
        locationManager.requestLocation()
    }
    
}
