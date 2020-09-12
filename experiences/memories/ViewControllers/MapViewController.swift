//
//  MapViewController.swift
//  memories
//
//  Created by Clayton Watkins on 9/11/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var location: CLLocationCoordinate2D?
    var postTitle: String?
    var postAuthor: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        setPinUsingMKPointAnnotation(location: location!)
    }
    
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = postTitle
        annotation.subtitle = postAuthor
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}

extension String {
    static let annotationReuseIdentifier = "PostLocationView"
}
