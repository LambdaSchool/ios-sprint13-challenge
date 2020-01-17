//
//  GeotagHelper.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-16.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import CoreLocation

class LocationHelper: NSObject {

    private(set) var currentLocation: CLLocationCoordinate2D?

    /// Returns nil if permission has not been requseted yet.
    var hasLocationPermission: Bool? {
        let authorization = CLLocationManager.authorizationStatus()
        switch authorization {
        case .notDetermined:
            return nil
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            print("Denied, restricted, or unknown case")
            return false
        }
    }

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = 30
        manager.distanceFilter = 30
        manager.activityType = .other
        return manager
    }()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    deinit {
        stopUpdatingLocation()
    }

    // MARK: - Public Methods

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func beginUpdatingLocation() {
        if let hasPermission = hasLocationPermission, hasPermission {
            locationManager.requestLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        currentLocation = nil
    }
}

// MARK: Location Manager Delegate

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let mostRecentLocation = locations.last?.coordinate {
            currentLocation = mostRecentLocation
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Error with location: \(error)")
    }
}
