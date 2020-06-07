//
//  ViewController.swift
//  Experiences
//
//  Created by Chris Dobek on 6/6/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class MapViewController: UIViewController {
        
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let experienceController = ExperienceController()
    var annotationTitle: String?
    var player: AVAudioPlayer?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPins()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    func loadPins() {
        for experience in ExperienceController.experiences {
            render(experience.location, experience: experience)
        }
    }
    
    func render(_ location: CLLocation, experience: Experience) {
        // location
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        // pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = experience.title
        mapView.addAnnotation(pin)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExperienceModally" {
            let newExperienceViewController = segue.destination as! AddNewExperienceViewController
            newExperienceViewController.mapRefreshDelegate = self
        }
    }
    
}

extension MapViewController: MapRefreshDelegate {
    func refreshMap() {
        loadPins()
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        // info button (should be play button though)
        let infoButton = UIButton()
        infoButton.frame.size.width = 44
        infoButton.frame.size.height = 44
        infoButton.backgroundColor = .none
        infoButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        if let annotationTitle = annotation.title {
            self.annotationTitle = annotationTitle
            infoButton.addTarget(self, action: #selector(playRecording), for: .touchUpInside)
        }
        annotationView?.rightCalloutAccessoryView = infoButton
        // imageView
        if let annotationTitle = annotation.title {
            if let annotationImage = loadExperience(withTitle: annotationTitle!)?.image {
                let scaledImage = annotationImage.imageByScaling(toSize: CGSize(width: 25, height: 25))
                annotationView?.image = scaledImage
            }
        }
        return annotationView
    }
    
    @objc func playRecording() {
        
        guard let experience = loadExperience(withTitle: self.annotationTitle!) else { return }
        player = try? AVAudioPlayer(contentsOf: experience.audio)
            player?.play()
    }
    
    func loadExperience(withTitle title: String) -> Experience? {
        ExperienceController.experiences.first { $0.title == title }
    }
    
}
