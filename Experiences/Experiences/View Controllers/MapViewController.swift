//
//  MapViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    let experienceController = ExperienceController()
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - IBActions
    @IBAction func addExperience(_ sender: Any) {
        performSegue(withIdentifier: "AddExperienceSegue", sender: self)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        updateViews()
    }
    
    func updateViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceMarker")
        mapView.addAnnotations(experienceController.experiences)
        
        guard let experience = experienceController.experiences.first else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: experience.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            let addExperienceVC = segue.destination as! AddExperienceViewController
            addExperienceVC.experienceController = experienceController
        }
    }

    @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue) {
        updateViews()
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {
            fatalError("Only Real Experiences are supported")
        }
        guard let markerView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceMarker", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view")
        }
        
        markerView.glyphImage = UIImage(systemName: "bolt.fill")
        markerView.canShowCallout = true
        let detailView = ExperienceDetailView()
        detailView.experience = experience
        markerView.detailCalloutAccessoryView = detailView
        
        return markerView
    }
}
