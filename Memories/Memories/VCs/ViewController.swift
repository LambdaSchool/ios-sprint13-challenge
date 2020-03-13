//
//  ViewController.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var data = Data()

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("NewMemory"), object: nil)
        
        mapView.delegate = self
        reload()
    }
    
    @objc func reload() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Memory")
        
        let memories = Helper.getMemories()

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(memories)
        
        guard let mostRecent = memories.last else { return }
        let region = MKCoordinateRegion(center: mostRecent.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let memory = annotation as? Memory else { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Memory", for: annotation) as? MKMarkerAnnotationView else { return nil }
        
        annotationView.canShowCallout = true
        let detailView = DetailView()
        detailView.memory = memory
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}

