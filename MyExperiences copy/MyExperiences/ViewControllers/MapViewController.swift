 //
//  MapViewController.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    var postController = PostController()
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let annotationReuseIdentifier = "PostAnnotationView"
           private var posts: [Post] = [] {
               didSet {
                   let oldPosts = Set(oldValue)
                   let newPosts = Set(self.posts)
                   let addedPosts = Array(newPosts.subtracting(oldPosts))
                   let removedPosts = Array(oldPosts.subtracting(newPosts))
                   mapView.removeAnnotations(removedPosts)
                   mapView.addAnnotations(addedPosts)
                   mapView.showAnnotations(self.posts, animated: true)
               }
           }

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postController.observePosts { (_) in
            print("TEST WORKED")
            for post in self.postController.posts where post.geotag != nil {
                self.posts.append(post)
            }
        }
        
    }
}

 
 // MARK: - Extensions
 extension MapViewController: MKMapViewDelegate {
         func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
             
         }
         
         func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
             guard let post = annotation as? Post else { return nil }
             
             guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: post) as? MKMarkerAnnotationView else {
                 fatalError("Missing registered map annotation view")
             }
             
             annotationView.canShowCallout = true
             annotationView.animatesWhenAdded = true
             annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
             
             return annotationView
         }
         
//         func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//             guard let post = view.annotation as? Post else { return }
//
//             // self.performSegue(withIdentifier: "DetailSegue", sender: post)
//         }
 }
