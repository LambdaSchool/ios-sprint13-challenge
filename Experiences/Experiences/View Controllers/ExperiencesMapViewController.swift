//
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by John Kouris on 1/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController {

    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var addExperienceButton: UIButton!
    @IBOutlet weak var experienceMapView: MKMapView!
    
    let experienceController = ExperienceController()
    
    var experiences = [Experience]() {
        didSet {
            let oldExperiences = Set(oldValue)
            let newExperiences = Set(experiences)
            let addedExperiences = Array(newExperiences.subtracting(oldExperiences))
            let removedExperiences = Array(oldExperiences.subtracting(newExperiences))
            experienceMapView.removeAnnotations(removedExperiences)
            experienceMapView.addAnnotations(addedExperiences)
        }
    }
    
    fileprivate let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    private let annotationReuseIdentifier = "ExperienceAnnotationView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        getCurrentLocation()
        
        experienceMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func configureViews() {
        buttonBackgroundView.layer.cornerRadius = 25
        buttonBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        addExperienceButton.tintColor = .white
    }
    
    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            guard let destinationVC = segue.destination as? ExperiencPostViewController else { return }
            destinationVC.experienceController = experienceController
        }
    }

}

// MARK: - Location Extension

extension ExperiencesMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

// MARK: - Map Extension

extension ExperiencesMapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: experience) as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }
        
        return annotationView
    }
}
