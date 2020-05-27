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
    private var isFetchingExperience = false
    private var shouldRequestExperience = false
   
    var experiences: [Experience] = [] {
        didSet {
            let previousExperiences = Set(oldValue)
            let newExperiences = Set(experiences)
            
            let addedExperieneces = Array(newExperiences.subtracting(previousExperiences))
            let removedExperiences = Array(previousExperiences.subtracting(newExperiences))
            
            mapView.removeAnnotations(removedExperiences)
            mapView.addAnnotations(addedExperieneces)
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
        
        guard !isFetchingExperience else {
            shouldRequestExperience = true
            return
        }
        
        isFetchingExperience = true
        
        let visibleMapRegion = mapView.visibleMapRect
        
        fetchExperiences(in: visibleMapRegion) { experiences in
            self.isFetchingExperience = false
            
            defer {
                if self.shouldRequestExperience {
                    self.shouldRequestExperience = false
                    self.fetchExperiences()
                }
            }
            
            self.experiences = Array(experiences.prefix(100))
        }
        
    }
    
    func fetchExperiences(in visibleRegion: MKMapRect? = nil, completion: @escaping ([Experience]) -> Void) {
        
        let regionExperiences = experienceController.experiences.filter {
            visibleRegion?.contains(MKMapPoint($0.coordinate)) ?? true }
        
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
