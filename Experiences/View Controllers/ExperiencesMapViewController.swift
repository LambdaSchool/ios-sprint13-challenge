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
    
    let reuseIdentifier = "ExperienceAnnotationView"
    @IBOutlet weak var mapView: MKMapView!
    
    //private let quakeFetcher = QuakeFetcher()
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
        
        locationManager.requestWhenInUseAuthorization()
        
        
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)
        
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
        //fetchQuakes()
    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: experience) as! MKMarkerAnnotationView
        experienceView.glyphImage = UIImage(named: "ExperienceIcon")
        experienceView.glyphTintColor = .white
        
        experienceView.canShowCallout = true
        let detailView = ExperienceDetailView()
        detailView.experience = experience
        experienceView.detailCalloutAccessoryView = detailView
        
        return experienceView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        //fetchQuakes()
    }
    
   
    
//    private func fetchExperiences() {
//        let currentArea = mapView.visibleMapRect
//        let currentRegion = CoordinateRegion(mapRect: currentArea)
////        quakeFetcher.fetchQuakes(in: currentRegion) { (quakes, error) in
////            if let error = error {
////                NSLog("Error fetching quakes: \(error)")
////            }
////            self.quakes = quakes ?? []
////        }
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }


}

