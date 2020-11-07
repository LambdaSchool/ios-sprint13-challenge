//
//  MapViewController.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK:  IBOutlets
    @IBOutlet var mapView: MKMapView!
    
    // MARK:  Properties
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    let experienceController = ExperienceController.shared
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showAnnotations(experienceController.experiences, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
