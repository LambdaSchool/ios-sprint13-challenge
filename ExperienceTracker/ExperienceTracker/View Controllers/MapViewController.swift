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

       
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.coordinate = location.coordinate
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ExperienceViewController
        if let coordinate = coordinate {
            experienceController.createNewExperience(title: nil, audioRecording: nil, videoRecording: nil, image: nil, coordinate: coordinate)
            let index = (experienceController.experiences.endIndex - 1)
            destVC.experience = experienceController.experiences[index]
        }
        destVC.experienceController = experienceController
    }
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    var coordinate: CLLocationCoordinate2D?
    
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
