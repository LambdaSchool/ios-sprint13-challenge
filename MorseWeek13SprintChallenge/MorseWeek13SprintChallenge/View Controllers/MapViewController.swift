//
//  ViewController.swift
//  MorseWeek13SprintChallenge
//
//  Created by morse on 1/17/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    let experinceController = ExperienceController()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(experinceController.experiences.count)
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: PropertyKeys.experienceView)
//        mapView.addAnnotations(experinceController.experiences)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let experience = experinceController.experiences.first else { return }
        
        mapView.addAnnotations(experinceController.experiences)
        
        let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
        
        let region = MKCoordinateRegion(center: experience.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }

    @IBAction func addExperienceTapped(_ sender: Any) {
        print(experinceController.experiences.count)
        if experinceController.experiences.count > 0,
            let photoURL = experinceController.experiences[0].photoURL,
            let audioURL = experinceController.experiences[0].audioURL,
            let videoURL = experinceController.experiences[0].videoURL {
            let photoData = try? Data(contentsOf: photoURL)
            print("Image: \(UIImage(data: photoData!))")
            let audioData = try? Data(contentsOf: audioURL)
            print("Audio: \(audioData)")
            let videoData = try? Data(contentsOf: videoURL)
            print("Video: \(videoData)")
        }
        performSegue(withIdentifier: PropertyKeys.createExperienceSegue, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.createExperienceSegue {
            guard let createVC = segue.destination as? CreateExperienceViewController else { return }
            createVC.experinceController = experinceController
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { fatalError("No coordinates") }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PropertyKeys.experienceView) as? MKMarkerAnnotationView else { fatalError("No view") }
        
        annotationView.canShowCallout = true
        annotationView.annotation = experience
        return annotationView
    }
}
