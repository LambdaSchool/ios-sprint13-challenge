//
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/20/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addExperienceButton: UIButton!
    
    // MARK: - Properties
    var experienceController = ExperienceController()
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    private var isCurrentlyFetchingExperiences = false
    private var shouldRequestExperiencesAgain = false
   
    var experiences: [Experience] = [] {
        didSet {
            let oldExperiences = Set(oldValue)
            let newExperiences = Set(experiences)
            
            let addedExperiences = Array(newExperiences.subtracting(oldExperiences))
            let removedExperiences = Array(oldExperiences.subtracting(newExperiences))
            
            mapView.removeAnnotations(removedExperiences)
            mapView.addAnnotations(addedExperiences)
        }
    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 60)
        ])
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifiers.annotation)
        
        fetchExperiences()
    }
   
    // MARK: - Fetch Functions
    private func fetchExperiences() {
        
        guard !isCurrentlyFetchingExperiences else {
            shouldRequestExperiencesAgain = true
            return
        }
        
        isCurrentlyFetchingExperiences = true
        
        let visibleMapRegion = mapView.visibleMapRect
        
        fetchExperiences(in: visibleMapRegion) { experiences in
            self.isCurrentlyFetchingExperiences = false
            
            defer {
                if self.shouldRequestExperiencesAgain {
                    self.shouldRequestExperiencesAgain = false
                    self.fetchExperiences()
                }
            }
            
            self.experiences = Array(experiences.prefix(100))
        }
        
    }
    
    func fetchExperiences(in region: MKMapRect? = nil, completion: @escaping ([Experience]) -> Void) {
        
        let regionExperiences = experienceController.experiences.filter { region?.contains(MKMapPoint($0.coordinate)) ?? true }
        
        completion(regionExperiences)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.AddExperienceSegue.rawValue {
            guard let destinationVC = segue.destination as? UINavigationController,
            
                let targetController = destinationVC.topViewController as? AddExperienceViewController else { return }
            
            targetController.experienceController = experienceController
        }
    }
}

// MARK: - Extensions
extension ExperiencesMapViewController: MKMapViewDelegate {
     
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchExperiences()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifiers.annotation, for: experience) as? MKMarkerAnnotationView else {
            preconditionFailure("Missing annotation view on map")
        }
        
        annotationView.canShowCallout = true
        let detailView = ExperienceView()
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}
