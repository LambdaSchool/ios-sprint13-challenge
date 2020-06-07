//
//  ViewController.swift
//  Experiences
//
//  Created by Shawn James on 6/5/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class ViewController: UIViewController {
        
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8 , height: 20))
    let locationManager = CLLocationManager()
    let experienceController = ExperienceController()
    var annotationTitle: String?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPins()
    }

    private func setupInitialViews() {
        setupSearchBar()
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search Feature Coming Soon"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
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
        // button
//        let pinView = MKAnnotationView(annotation: pin, reuseIdentifier: "Pin")
//        let infoButton = UIButton()
//        infoButton.setImage(UIImage(systemName: "info")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        infoButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        pinView.rightCalloutAccessoryView = infoButton
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToNewExperience" {
            let newExperienceViewController = segue.destination as! NewExperienceViewController
            newExperienceViewController.mapRefreshDelegate = self
        }
    }
    
}

extension ViewController: MapRefreshDelegate {
    func refreshMap() {
        loadPins()
    }
    
}

extension ViewController: MKMapViewDelegate {
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
            if let annotationImage = loadExperience(withTitle: annotationTitle!)?.photo {
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
