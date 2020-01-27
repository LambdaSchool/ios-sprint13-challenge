//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperiencesViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var mapView: MKMapView!
    
    private let postController = PostController()
    private let locationManager = CLLocationManager()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show user location
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
        
        self.locationManager.delegate = self
        
        self.postController.didChange = { posts in
            self.posts = posts
        }

        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        self.postController.currentLocation = location
    }
    
    @IBAction func videoPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddVideo", sender: nil)
    }
    
    @IBAction func audioPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddAudio", sender: nil)
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVideo" {
            if let videoVC = segue.destination as? VideoViewController {
                videoVC.postController = self.postController
            }
        }
        
        if segue.identifier == "AddAudio" {
            if let audioVC = segue.destination as? AudioViewController {
                audioVC.postController = self.postController
            }
        }
        
        if segue.identifier == "AddImage" {
            if let imageVC = segue.destination as? ImageViewController {
                imageVC.postController = self.postController
            }
        }
    }
}

extension ExperiencesViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let post = annotation as? Post else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: post) as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }
        
        annotationView.canShowCallout = true
        annotationView.animatesWhenAdded = true
        return annotationView
    }
}

