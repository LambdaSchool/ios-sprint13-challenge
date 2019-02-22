//
//  MapViewController.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    private let experienceController = ExperienceController()
    private var experiences: Set<Experience> = [] {
        didSet { updateExperienceAnnotations(oldValue) }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationHelper.shared.requestAccess(completion: { granted in
            DispatchQueue.main.async {
                if granted {
                    let userTrackingButton = MKUserTrackingButton(mapView: self.mapView)
                    userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
                    self.mapView.addSubview(userTrackingButton)
                    
                    userTrackingButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
                    userTrackingButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
                }
            }
        })
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        mapView.delegate = self
        fetchExperiences()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchExperiences), name: .newExperienceNotification, object: nil)
    }
    
    // MARK: - MK Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Experience else { return nil }
        
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: annotation) as! MKMarkerAnnotationView
        
        return experienceView
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UINavigationController {
            let newExperienceVC = destinationVC.children.first! as! NewExperienceViewController
            newExperienceVC.experienceController = experienceController
        }
    }
    
    // MARK: - Utility Methods
    @objc private func fetchExperiences() {
        experiences = experienceController.experiencesWithAnnotations()
    }

    private func updateExperienceAnnotations(_ oldValue: Set<Experience>) {
        
        let addedExperiences = experiences.subtracting(oldValue)
        let removeExperiences = oldValue.subtracting(experiences)
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(Array(removeExperiences))
            self.mapView.addAnnotations(Array(addedExperiences))
        }
    }
}
