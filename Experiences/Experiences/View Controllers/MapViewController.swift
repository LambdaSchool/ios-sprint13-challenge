//
//  MapViewController.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    //MARK: - Properties -
    let experienceController = ExperienceController.shared
    
    //MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Methods -
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showAnnotations(experienceController.experiences, animated: true)
    }

} //End of class

//Custome annotation view attempt
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier) {
            annotationView.annotation = annotation
            annotationView.image = UIImage(named: "Pin")
            annotationView.canShowCallout = true
            return annotationView
        }
        else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: .annotationReuseIdentifier)
            annotationView.annotation = annotation
            annotationView.image = UIImage(named: "Pin")
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
} //End of extension
