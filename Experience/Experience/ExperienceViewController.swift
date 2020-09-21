//
//  ExperienceViewController.swift
//  Experience
//
//  Created by Lambda_School_Loaner_241 on 9/19/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import UIKit
import MapKit

class ExperienceViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addExperienceButton: UIBarButtonItem!
    var network = Networking()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExpSegue" {
            if let detailVC = segue.destination as? ExperienceDetailViewController {
                
                detailVC.network = network
                
                
            }
            
        }
    }
    
    // Task from 2nd unit
    
    
    
   
    
   
}
