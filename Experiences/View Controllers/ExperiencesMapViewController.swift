//  self.navigationController?.setNavigationBarHidden(true, animated: animated)
//  let reuseIdentifier = "ExperienceAnnotationView"
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import MapKit



class ExperiencesMapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addNewExperienceButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private var experiencesAnnotations = Array<Experience>() {
        didSet {
            let oldExperiencesAnnotations = Set(oldValue)
            let newExperiencesAnnotations = Set(experiencesAnnotations)
            
            let addedExperiencesAnnotations = newExperiencesAnnotations.subtracting(oldExperiencesAnnotations)
            let removedExperiencesAnnotations = oldExperiencesAnnotations.subtracting(newExperiencesAnnotations)
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(Array(removedExperiencesAnnotations))
                self.mapView.addAnnotations(Array(addedExperiencesAnnotations))
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        experiencesAnnotations = Experiences.experiences
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewExperienceButton.backgroundColor = .purple
        locationManager.requestWhenInUseAuthorization()
        
        
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        userTrackingButton.tintColor = .purple
        mapView.tintColor = .purple
        mapView.addSubview(userTrackingButton)
        
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30).isActive = true
        userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 30).isActive = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        fetchExperiences()
    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experienceInfo = annotation as? Experience else { return nil }
        
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experienceInfo) as! MKMarkerAnnotationView
        experienceView.markerTintColor = .purple
        experienceView.glyphImage = UIImage(named: "ExperienceIcon")
        experienceView.glyphTintColor = .white
        
        experienceView.canShowCallout = true
        let detailView = ExperienceDetailView()
        detailView.experience = experienceInfo
        experienceView.detailCalloutAccessoryView = detailView
        
        return experienceView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchExperiences()
        mapView.reloadInputViews()
    }
    
   
    
    private func fetchExperiences() {
            self.experiencesAnnotations = Experiences.experiences
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }


}

