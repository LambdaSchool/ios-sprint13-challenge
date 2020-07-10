//
//  MapViewController.swift
//  Experiences
//
//  Created by Enayatullah Naseri on 3/21/20.
//  Copyright © 2020 Enayatullah Naseri. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    let experienceController = ExperienceController()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    

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
            
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: lastExperience.coordinate, span: coordinateSpan)
            self.mapView.setRegion(region, animated: true)
        }
    }
    

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExperience" {
            if let addExperienceVC =  segue.destination as? AddExperienceViewController {
                addExperienceVC.experienceController = experienceController
            }
        }
    }
    
    
    
    // MARK: - action outlets
    @IBAction func addExperienceTaped(_ sender: Any) {
        performSegue(withIdentifier: "addExperience", sender: self)
    }
    
    
    // MARK: - Delegate
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let experience = annotation as? Experience else {
                fatalError("Failed to find expeience")
            }
            
            let identifier = "CustomAnnotation"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }

            configureDetailView(annotationView: annotationView!, experience: experience)
            
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
