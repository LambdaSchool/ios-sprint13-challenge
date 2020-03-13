//
//  MapkitViewController.swift
//  Experiences
//
//  Created by Aaron Cleveland on 3/13/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import MapKit

class MapkitViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var expController = ExpController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotations()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordExperience" {
            
            guard let navController = segue.destination as? UINavigationController,
                let destinationVC = navController.children.first as? ExpViewController else { return }
            destinationVC.expController = expController
        }
    }

}

extension MapkitViewController: MKMapViewDelegate {
    func addAnnotations() {
        let experiences = Set(expController.experiences)
        
        let currentAnnotations = Set(mapView.annotations.compactMap({ $0 as? Experience }))
        
        let addedExperiences = Array(experiences.subtracting(currentAnnotations))
        
        mapView.addAnnotations(addedExperiences)
    }
    
}
