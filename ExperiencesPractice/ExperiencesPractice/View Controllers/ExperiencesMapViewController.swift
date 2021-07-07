//
//  ExperiencesMapViewController.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/11/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController, MKMapViewDelegate {
    
    var experiences: [Experience] = []
    
    var count = 0

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if count == 0 {
            
            //mapView.delegate = self
            let newestAnnotation = MKPointAnnotation()
            newestAnnotation.title = "SmooveTest"
            newestAnnotation.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
            mapView.addAnnotation(newestAnnotation)
            
            count += 1
        } else {
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
            mapView.addAnnotations(experiences)
        }
    }
    
    func createExperience(name: String, image: UIImage, audioRecording: URL, longitude: Double, latitude: Double, videoRecording: URL) {
        
         let newExperience = Experience(name: name, image: image, audioRecording: audioRecording, videoRecording: videoRecording, longitude: longitude, latitude: latitude)
        
        
        experiences.append(newExperience)
        
    }
             //name: String, image: UIImage, audioRecording: URL, videoRecording: URL, longitude: Double, latitude: Double
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "ExperienceAnnoationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}


