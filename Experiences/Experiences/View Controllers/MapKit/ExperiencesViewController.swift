//
//  ViewController.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var journalButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ExperiencesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: annotation) as! MKMarkerAnnotationView
        
        return annotationView
    }
}
