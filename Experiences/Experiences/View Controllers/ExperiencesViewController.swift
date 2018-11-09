//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private let geoCoder = CLGeocoder()
    private var coordinate: CLLocationCoordinate2D?
    let experienceController = ExperienceController()
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchExperiences()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        fetchExperiences()
    }
    
    private func fetchExperiences() {
        self.mapView.addAnnotations(experienceController.experiences)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            guard let coordinate = coordinate,
                let destVC = segue.destination as? NewExperienceViewController else { return }
            
            destVC.coordinate = coordinate
            destVC.experienceController = experienceController
        }
    }
}

extension ExperiencesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return annotationView
    }
}

extension ExperiencesViewController: CLLocationManagerDelegate {
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

