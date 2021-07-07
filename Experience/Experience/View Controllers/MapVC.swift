//
//  MapVC.swift
//  Experience
//
//  Created by Nikita Thomas on 1/18/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let experienceCont = ExperienceController()
    var experiences: [Experience] = []
  

    // Done in viewWillAppear so we can popToRoot and load new annotations
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove the old annotations so we're not creating duplicates of the old ones
        mapView.removeAnnotations(mapView.annotations)
        
        // Add all annotations which will include the new ones
        mapView.addAnnotations(experienceCont.experiences)
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewExperience" {
            let dest = segue.destination as! NewExperienceVC
            dest.experienceCont = experienceCont
        }
    }
    

}
