//
//  ExperienceMapViewController.swift
//  Media Programming Sprint
//
//  Created by Lambda_School_Loaner_95 on 4/28/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import MapKit

protocol ExperienceControllerInheriting: class {
    var experienceController: ExperienceController! { get set }
}

class ExperienceMapViewController: UIViewController, MKMapViewDelegate {
    var experienceController: ExperienceController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
        Location.shared.getCurrentLocation { (coordinate) in
            print("Coordinate: \(coordinate)")
            self.experienceController?.createExperience(withTitle: "Garden", andGeo: coordinate!, mediaTypeOne: .image, mediaTypeTwo: .video, mediaTypeThree: .audio)
            // print("Experiences: \(self.experienceController.experiences)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(mapView.annotations)
        
    
        
        let annotations = self.experienceController?.experiencesWithGeotags.compactMap({ ExperienceAnnotation(experience: $0) })
        self.mapView.addAnnotations(annotations ?? [ExperienceAnnotation(experience: exp)!])
        
       // print("Experiences: \(experienceController.experiences)")
        
       
    }
    var exp = Experience(title: "Goose", mediaTypeOne: .image, mediaTypeTwo: .video, mediaTypeThree: .audio, geotag: CLLocationCoordinate2D(latitude: 37.7749, longitude: 122.4194))
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let av = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else { return nil }
        
        av.titleVisibility = .adaptive
        av.subtitleVisibility = .adaptive
        
        return av
    }
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    let annotationReuseIdentifier = "ExperienceAnnotation"
    
    @IBAction func addExperienceTapped(_ sender: UIButton) {
    }
    @IBOutlet weak var mapView: MKMapView!
}
