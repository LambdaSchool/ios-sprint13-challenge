//
//  MapViewController.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var mapView: MKMapView!


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Actions
    
    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        print("button tapped")
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
