//
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class ExperiencesMapViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    var experiences = [Experience]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        fetchExperiences()
    }
    
    private func fetchExperiences() {
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
        do {
            self.experiences = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            self.mapView.addAnnotations(experiences)
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ExperiencesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation as? Experience != nil else { fatalError("Only experiences are supported") }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else { fatalError("Missing a registered annotation view.") }
        annotationView.glyphImage = UIImage(systemName: "person")
        annotationView.markerTintColor = .systemGreen
        annotationView.glyphTintColor = .black
        return annotationView
    }
}
