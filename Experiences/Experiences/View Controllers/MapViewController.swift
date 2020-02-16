//
//  MapViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    let identifier = "Experience"
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateVIews()
    }
    
//MARK: - actions
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "add", message: "choose which one you'd like to add", preferredStyle: .actionSheet)
        let canceAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let pictureAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            guard let pictureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PictureVC") as? PictureViewController else { return }
            pictureVC.modalPresentationStyle = .fullScreen
            pictureVC.experienceController = self.experienceController
            self.present(pictureVC, animated: true, completion: nil)
        }
        
        let recordingAction = UIAlertAction(title: "Recording", style: .default) { (_) in
            guard let recordingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordingVC") as? RecordingViewController else { return }
            recordingVC.modalPresentationStyle = .fullScreen
            recordingVC.experienceController = self.experienceController
            self.present(recordingVC, animated: true, completion: nil)
        }
        alert.addAction(pictureAction)
        alert.addAction(recordingAction)
        alert.addAction(canceAction)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - helper methods
    private func updateVIews() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(self.experienceController.experiences)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
            
        }
    }
    
    private func checkAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        @unknown default:
            fatalError("unable to check authorization")
        }
    }
    
    private func configureViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: identifier)
       mapView.addAnnotations(experienceController.experiences)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView else { return nil}
            annotationView.annotation = annotation
            annotationView.displayPriority = .required
            annotationView.canShowCallout = true
            annotationView.clusteringIdentifier = identifier
        return annotationView
       }
    
    @IBAction func unwindToMapView(_ unwindSegue: UIStoryboardSegue) {
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
