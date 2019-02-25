//
//  MapViewController.swift
//  Exp
//
//  Created by Madison Waters on 2/22/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    @IBAction func addExp(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.main.async {
            guard let exp = self.exp else { return }
            self.mapView.addAnnotation(self.expController.placeAnExp(exp: exp))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            guard let exp = self.exp else { return }
            self.mapView.addAnnotation(self.expController.placeAnExp(exp: exp))
        }
        
        let lindon = MKPointAnnotation()
        lindon.title = "Lindon"
        
        let userLocation = MKUserLocation()
        lindon.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        self.mapView.addAnnotation(userLocation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let exp = annotation as? Exp else { return nil }
        
        let expView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExpAnnotationView", for: exp as! MKAnnotation) as! MKMarkerAnnotationView
        
        expView.canShowCallout = true
        let detailView = ExpMapDetailView()
        detailView.exp = exp
        expView.detailCalloutAccessoryView = detailView
        
        return expView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExp" {
            let newExpVC = segue.destination as? ExpDetailViewController
            newExpVC?.exp = exp
        }
    }
    
    var exp: Exp?
    let expController = ExpController()
}
