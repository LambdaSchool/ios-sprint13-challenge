//
//  MapViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_34 on 3/29/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties
    let experienceController = ExperienceController()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func start(_ sender: Any) {
        performSegue(withIdentifier: "createExperience", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createExperience" {
            guard let destination = segue.destination as? UINavigationController, let vcDestination = destination.topViewController as? PhotoRecordViewController else { return }
            
            vcDestination.experienceController = experienceController
        }
    }
}
