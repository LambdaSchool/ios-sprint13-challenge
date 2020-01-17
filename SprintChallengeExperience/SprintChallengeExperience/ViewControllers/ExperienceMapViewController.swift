//
//  ExperienceMapViewController.swift
//  SprintChallengeExperience
//
//  Created by Jerry haaser on 1/17/20.
//  Copyright © 2020 Jerry haaser. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController {
    
    private let geoCoder = CLGeocoder()
    private var coordinate: CLLocationCoordinate2D?
    let experienceController = ExperienceController()
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        fetchExperiences()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        fetchExperiences()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchExperiences()
    }
    
    private func fetchExperiences() {
        self.mapView.addAnnotations(experienceController.experiences)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            guard let coordinate = coordinate,
                let vc = segue.destination as? NewExperienceViewController else { return }
            
            vc.coordinate = coordinate
            vc.experienceController = experienceController
        }
    }

}

extension ExperienceMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error geocoding location: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first,
                let latitude = placemark.location?.coordinate.latitude,
                let longitude = placemark.location?.coordinate.longitude else { return }
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Failed getting location with error: \(error)")
        return
    }
}

extension ExperienceMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return annotationView
    }
}
