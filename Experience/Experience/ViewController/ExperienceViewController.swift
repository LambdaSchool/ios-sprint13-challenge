//
//  ExperienceViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import MapKit

class ExperienceViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ExperienceViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard let experience = annotation as? Experience else {
//            fatalError("Only quakes are supported")
//        }
//
//        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView", for: annotation) as? MKMarkerAnnotationView else {
//            fatalError("Missing a registered view")
//        }
//
//        annotationView.canShowCallout = true
//
//        return annotationView
//    }
}
