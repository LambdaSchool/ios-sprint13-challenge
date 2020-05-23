//
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import CoreData
import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController {
    var experiences = [Experience]()
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        fetchExperiences()
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
    
    private func fetchExperiences() {
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true)]
        do {
            self.experiences = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            self.mapView.addAnnotations(experiences)
        } catch {
            print("Error fetching experiences: \(error)")
        }
    }
}

extension ExperiencesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation as? Experience != nil else { fatalError("Only Experiences are supported.") }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else { fatalError("Missing a registered Annotation View.")}
            annotationView.glyphImage = UIImage(systemName: "person")
            annotationView.markerTintColor = .systemRed
            annotationView.glyphTintColor = .label
            return annotationView
        
        
    }
}
