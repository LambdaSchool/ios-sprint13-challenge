//
//  MapViewController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocationCoordinate2D?
    var postTitle: String
    var postAuthor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.mapType = .standard
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        setPinUsingMKPointAnnotation(location: location!)

    }
    
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D) {
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
