//
//  MapViewViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewViewController: UIViewController {
    
    var experience: Experience?
    var experiences: [Experience]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchExperiences()
        
    }
    
    func fetchExperiences() {
        
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        do {
            experiences = try CoreDataStack.context.fetch(fetchRequest)
            print(experiences!)
        } catch {
            print(error)
        }
        
        if let experiences = experiences {
            print(experiences.count)
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(experiences)
                
                let location = CLLocationCoordinate2D(latitude: 33.812794,
                                                      longitude: -117.9190981)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView.setRegion(region, animated: true)
                
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
            }
        }
    }
}

extension MapViewViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {
            fatalError("FatalError.......")
        }
        
        // get annotation view from reusable settings
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }
        
        // use a new icon
        
        //        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        
        // color it based on severity
        
        //        if quake.magnitude >= 5 {
        //            annotationView.markerTintColor = .red
        //        } else if quake.magnitude >= 3 && quake.magnitude < 5 {
        //            annotationView.markerTintColor = .orange
        //        } else {
        //            annotationView.markerTintColor = .yellow
        //        }
        
        // show popup
        ////
        //        annotationView.canShowCallout = true
        //        let detailView = QuakeDetailView()
        //        detailView.quake = quake
        //        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}

