//
//  MapViewController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newExperienceButton: UIButton!
    
    
    // USER BUTTON HIDES THE MKAnnotation
//    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    
    var experienceController = ExperienceController()
    var experiences: [Experience] = [] {
        didSet {
            mapView.addAnnotations(experiences)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        userTrackingButton = MKUserTrackingButton(mapView: mapView)
//
//        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(userTrackingButton)
//
//        userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20).isActive = true
//        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
        
        locationManager.delegate = self
        zoomToUserLocation()
        fetchExperiences()
        
//        let annotation = MKPointAnnotation()
//        if let coordinate = locationManager.location?.coordinate {
//            annotation.coordinate = coordinate
//            annotation.title = "Test"
//            mapView.addAnnotation(annotation)
//        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExperiences()
        mapView.showAnnotations(experiences, animated: true)
    }
    
    func zoomToUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 12000, longitudinalMeters: 12000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func fetchExperiences() {
        experiences = experienceController.experiences
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExperienceSegue" {
            if let addExperienceVC = segue.destination as? AddExperienceViewController {
                addExperienceVC.experienceController = experienceController
                addExperienceVC.delegate = self
            }
        }
    }
    
    @IBAction func newExperienceTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewExperienceSegue", sender: self)
    }
    
}


extension MapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchExperiences()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 12000, longitudinalMeters: 12000)
        mapView.setRegion(region, animated: true)
    }
}


extension MapViewController: MapViewReloadDelegate {
    func refreshMap() {
        fetchExperiences()
    }
}
