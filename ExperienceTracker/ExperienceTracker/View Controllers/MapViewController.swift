//
//  MapViewController.swift
//  ExperienceTracker
//
//  Created by Jonathan T. Miles on 10/19/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error with location manager:\(error)")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ExperienceViewController

        if let location = locationManager.location {
            experienceController.createNewExperience(title: nil, audioRecording: nil, videoRecording: nil, image: nil, coordinate: location.coordinate)
            let index = (experienceController.experiences.endIndex - 1)
            destVC.experience = experienceController.experiences[index]
            
        }
        
        destVC.experienceController = experienceController
    }
    
    @IBAction func unwindFromVideoScreen(segue: UIStoryboardSegue) {
        if let fromVC = segue.source as? VideoViewController {
            if let experienceController = fromVC.experienceController {
                self.experienceController.experiences = experienceController.experiences
                if let experience = fromVC.experience,
                    let videoRecording = fromVC.recordOutput.outputFileURL {
                    experienceController.updateVideoURL(experience: experience, videoRecording: videoRecording)
                }
            
            }
        }
    }
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    // var coordinate: CLLocationCoordinate2D?
    var location: CLLocation?
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    } ()
    private let geocoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func addExperienceButton(_ sender: Any) {
    }
    
}
