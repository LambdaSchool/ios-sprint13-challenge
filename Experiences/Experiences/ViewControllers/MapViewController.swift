//
//  MapViewController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var experienceController: ExperienceController?
    var experience: [Experience] = []

    override func viewDidLoad() {
        super.viewDidLoad()
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
