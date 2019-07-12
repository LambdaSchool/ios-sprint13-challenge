//
//  MapViewController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var experienceController: ExperienceController?
    var experience: [Experience] = []
    let locationHelper = LocationHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        goToUser()
        addAnnotation()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as? MKMarkerAnnotationView
        
        annotationView?.glyphText = experience.title
        annotationView?.titleVisibility = .visible
        
        return annotationView
    }
    
    
    
    
    func addAnnotation() {
        let userAnnotation = MKPointAnnotation()
        if let userCoordinate = experienceController?.latestExperience?.coordinate {
            userAnnotation.coordinate = userCoordinate
        }
        
        if let annotationTitle = experienceController?.latestExperience?.title {
            userAnnotation.title = annotationTitle
        }
    
        mapView.addAnnotation(userAnnotation)
    }
    
    func goToUser() {
        print(locationHelper.currentLocation)
        if let location = locationHelper.currentLocation?.coordinate {
            let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 12000, longitudinalMeters: 12000)
            mapView.setRegion(viewRegion, animated: true)
        }
        
    }
    


}
