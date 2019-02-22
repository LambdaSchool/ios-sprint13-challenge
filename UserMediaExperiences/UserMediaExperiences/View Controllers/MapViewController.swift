//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Andrew R Madsen on 10/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Private Properties
    private let locationManager = CLLocationManager()
    private let quakeFetcher = QuakeFetcher()
    private var quakes = Array<Quake>() {
        didSet {
            let oldQuakes = Set(oldValue)
            let newQuakes = Set(quakes)
            
            //new - old = what was added
            //old - new = what was removed
            
            let addedQuakes = newQuakes.subtracting(oldQuakes)
            let removedQuakes = oldQuakes.subtracting(newQuakes)
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(Array(removedQuakes))
                self.mapView.addAnnotations(Array(addedQuakes))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        //The user tracking mode is inferred from the mapView that we pass in
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        //Use auto layout
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        //Add button to mapView
        mapView.addSubview(userTrackingButton)
        //Add constraints
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeAnnotationView")
        
        fetchQuakes()
    }
    
    //MARK: MapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let quake = annotation as? Quake else { return nil}
        let quakeView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeAnnotationView", for: quake) as! MKMarkerAnnotationView
        
        quakeView.glyphImage = UIImage(named: "QuakeIcon")
        quakeView.glyphTintColor = .white
        
        quakeView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        quakeView.detailCalloutAccessoryView = detailView
        
        return quakeView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchQuakes()
    }
    
    //MARK: Private Methods
    private func fetchQuakes() {
        let currentArea = mapView.visibleMapRect
        let currentRegion = CoordinateRegion(mapRect: currentArea)
        quakeFetcher.fetchQuakes(in: currentRegion) { (quakes, error) in
            if let error = error {
                NSLog("Error fetching quakes in EarthQuakesViewController: \(error)")
            }
            self.quakes = quakes ?? []
        }
    }
    
}
