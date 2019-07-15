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
    
    
    var count = 0
    let newestAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
//        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
//
//        mapView.addAnnotations(experiences)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if count == 0 {
            print("viewDidAppear first time")
            
            mapView.delegate = self
            newestAnnotation.title = "SmooveTest"
            newestAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.04, longitude: 74.05)
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

}




extension ExperiencesMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

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

