//
//  MapViewController.swift
//  Experiences-sprint-chanllenge
//
//  Created by Gi Pyo Kim on 12/6/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let experienceController = ExperienceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")

        fetchExperiences()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExperiences()
    }
    
    private func fetchExperiences() {
        let experiences = experienceController.experiences
        DispatchQueue.main.async {
            self.mapView.addAnnotations(experiences)
            
            guard let lastExperience = experiences.last else { return }
            
            // Zoom to latest experience
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: lastExperience.coordinate, span: coordinateSpan)
            self.mapView.setRegion(region, animated: true)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            if let addExperienceVC =  segue.destination as? AddExperienceViewController {
                addExperienceVC.experienceController = experienceController
            }
        }
    }
    
    
    
    @IBAction func createNewExperience(_ sender: Any) {
        performSegue(withIdentifier: "NewExperienceSegue", sender: self)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {
            fatalError("Experience object not found in map")
        }
        
        let identifier = "CustomAnnotation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        // change pin to be the images
        configureDetailView(annotationView: annotationView!, experience: experience)
        
//        // play video recording in detail view
//        annotationView.canShowCallout = true
//        let detailView = MapDetailView()
//        detailView.experience = experience
//        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let mapDetailView = view.detailCalloutAccessoryView as? MapDetailView else { return }
        
        mapDetailView.player?.play()
    }
    
    func configureDetailView(annotationView: MKAnnotationView, experience: Experience) {
        let width = 300
        let height = 200

        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(300)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(200)]", options: [], metrics: nil, views: views))

        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: width, height: height)

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if snapshot != nil {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(data: experience.imageData)
                snapshotView.addSubview(imageView)
            }
        }
            
        

        annotationView.detailCalloutAccessoryView = snapshotView
    }
}
