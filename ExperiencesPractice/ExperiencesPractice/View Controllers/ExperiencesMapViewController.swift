//
//  ExperiencesMapViewController.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/11/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController {
    
    var experiences: [Experience] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
        mapView.addAnnotations(experiences)
    }
    
    func createExperience(name: String, image: UIImage, audioRecording: URL, videoRecording: URL, longitude: Double, latitude: Double) {
        
        let newExperience = Experience(name: name, image: image, audioRecording: audioRecording, videoRecording: videoRecording, longitude: longitude, latitude: latitude)
        
        experiences.append(newExperience)
        
    }


}




extension ExperiencesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // create an annotation view
        
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: annotation) as! MKMarkerAnnotationView
        
        annotationView.glyphImage = UIImage(named: "ExperienceIcon")
        annotationView.glyphTintColor = .white
        annotationView.markerTintColor = .blue
        
        annotationView.canShowCallout = true
        let detailView = ExperienceDetailView(frame: .zero)
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView

        
        return annotationView
    }
    
    
}

