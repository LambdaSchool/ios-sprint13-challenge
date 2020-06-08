//
//  MapViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
        var postController: PostController?
    
        @IBOutlet var mapView: MKMapView!

        override func viewDidLoad() {
            super.viewDidLoad()
            mapView.delegate = self
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PostView")
            // Do any additional setup after loading the view.
            fetchPosts()
        }

        private func fetchPosts() {
            
            guard let posts = postController?.posts else { return }
            
            DispatchQueue.main.async {
                
                self.mapView.addAnnotations(posts)
                
                guard let post = posts.first else { return }
                
                let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                let region = MKCoordinateRegion(center: post.MKCoordinateRegion.latitudeDelta, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }

    extension MapViewController: MKMapViewDelegate {

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            guard let _ = annotation as? Post else {
                fatalError("Only Posts are supported right now")
            }

            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PostView") as? MKMarkerAnnotationView else {
                fatalError("Missing registered map annotation view")
            }

            return annotationView
        }
}
