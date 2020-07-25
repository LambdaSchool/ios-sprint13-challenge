//
//  MapViewController.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0,
                                                                     longitude: 0)

class MapViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var experienceMapView: MKMapView!
    
    //MARK: - Properties
    private var userTrackingButton: MKUserTrackingButton!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10_000
    var experienceController: ExperienceController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        experienceMapView.delegate = self
        experienceMapView.register(MKMarkerAnnotationView.self,
                                   forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        guard let experiences = experienceController?.experiences else {
            print("Did not unwrap experiences.")
            return
        }
        print("Name for first annotation: \(experiences.first?.name)")
        experienceMapView.addAnnotations(experiences)
        print("The count of experiences: \(experienceController?.experiences.count)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        userTrackingButton = MKUserTrackingButton(mapView: experienceMapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: experienceMapView.leadingAnchor,
                                                        constant: 20),
            experienceMapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor,
                                                      constant: 20)
        ])
        
        experienceMapView.delegate = self
        checkLocationServices()
        experienceMapView.register(MKMarkerAnnotationView.self,
                                   forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        guard let experiences = experienceController?.experiences else {
            print("Did not unwrap experiences.")
            return
        }
        experienceMapView.addAnnotations(experiences)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting user know they have to turn this on
            print("Go to your Settings > Privacy > Location Services > turn on")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            experienceMapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: regionInMeters,
                                                 longitudinalMeters: regionInMeters)
            experienceMapView.setRegion(region, animated: true)
            print(currentLocation)
            currentLocation = location
            print(currentLocation)
        }
    }
}
//
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier,
                                                                         for: experience) as? MKMarkerAnnotationView else {
                                                                            fatalError("Missing the registered map annotation view")
        }
        annotationView.canShowCallout = true
        
        print(annotationView)
        return annotationView
    }
}
extension MapViewController: CLLocationManagerDelegate {
    
    // Updates users location
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.07,
                                    longitudeDelta: 0.07)
        let region = MKCoordinateRegion(center: center, span: span)
        
        experienceMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    // Alerts when authorization changes
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension String {
    static let annotationReuseIdentifier = "Experience Annotation"
}
