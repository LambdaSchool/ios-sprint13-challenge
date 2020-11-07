//
//  MapViewController.swift
//  Experiences
//
//  Created by Rob Vance on 11/6/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // Mark: - Properties -
    let experienceController = ExperienceController.shared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showAnnotations(experienceController.experiences, animated: true)
    }
    
    // MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
