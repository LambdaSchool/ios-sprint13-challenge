//
//  MapViewController.swift
//  EXP
//
//  Created by Madison Waters on 2/22/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    private var exp: Exp? {
        didSet {
            guard (exp?.location) != nil else { return }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations([(self.exp?.location)!])
            }
        }
    }
    
    @IBAction func addExp(_ sender: Any) {
        addExps()
        print(mapView.annotations)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func addExps() {
        let currentArea = mapView.visibleMapRect
        let currentRegion = CoordinateRegion(mapRect: currentArea)
        
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
