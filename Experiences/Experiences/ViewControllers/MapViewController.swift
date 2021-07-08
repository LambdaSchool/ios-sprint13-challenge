//
//  MapViewController.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
        fetchExperiences()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExperiences()
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        experienceView.clusteringIdentifier = "identifier"
        experienceView.glyphImage = UIImage(named: "airdrop")
        experienceView.glyphTintColor = .black
        
        experienceView.canShowCallout = true
//        let detailView = QuakeDetailView()
//        detailView.quake = quake
//        quakeView.detailCalloutAccessoryView = detailView
        
        return experienceView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchExperiences()
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let test = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        
        return test
    }
    
    // MARK: - Private Methods
    private func fetchExperiences() {
        let currentArea = mapView.visibleMapRect
        let currentRegion = CoordinateRegion(mapRect: currentArea)
        self.experiences = Experiences.shared.getExperiences()
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    private var experiences = Array<Experience>() {
        didSet {
            let oldExperiences = oldValue
            let newExperiences = experiences
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(oldExperiences)
                self.mapView.addAnnotations(newExperiences)
            }
        }
    }
    
}
