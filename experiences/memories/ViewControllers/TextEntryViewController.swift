//
//  TextEntryViewController.swift
//  memories
//
//  Created by Clayton Watkins on 9/10/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import MapKit

class TextEntryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    // MARK: - Properties
    let postController = PostController.shared
    let locationManager = CLLocationManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
    }
    
    // MARK: Private
    private func getCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - IBAction
    @IBAction func saveEntryTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let entry = entryTextView.text, !entry.isEmpty else { return }
        guard let location = locationManager.location?.coordinate else { return }
        postController.createTextPost(with: title, entry: entry, location: location)
    }
    
}
