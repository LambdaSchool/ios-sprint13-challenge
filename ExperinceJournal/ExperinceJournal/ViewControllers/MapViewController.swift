//
//  MapViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var entryController: EntryController?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self as? MKMapViewDelegate
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "")
        
        
    }
    
    func getEntry() {
        var entry = entryController.s
    }
    

    

}
