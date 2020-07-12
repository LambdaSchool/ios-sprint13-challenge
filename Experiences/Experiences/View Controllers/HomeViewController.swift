//
//  HomeViewController.swift
//  Experiences
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController {
    //MARK: - Properties -
    var experiences: [Experience] = []
    var persistenceController = PersistenceController()
    var locationManager = CLLocationManager()
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        let experiences = persistenceController.loadExperiences()
        self.experiences = experiences
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .listSegue {
            guard let ListVC = segue.destination as? ExperiencesTableViewController else { return }
            ListVC.experiences = experiences
        }
        
        if segue.identifier == .mapSegue {
            guard let MapVC = segue.destination as? ExperiencesMapViewController else { return }
            MapVC.experiences = experiences
            MapVC.locationManager = locationManager
        }
    }
    

}
