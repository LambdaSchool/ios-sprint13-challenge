//
//  TextViewController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import MapKit

class TextViewController: UIViewController {
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    let postExperiencesController = PostExperiencesController.shared
    let locationManager = CLLocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
    private func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func saveMemoTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let memo = memoTextView.text, !memo.isEmpty else { return }
        guard let location = locationManager.location?.coordinate else { return }
        postExperiencesController.createText(with: title, entry: memo, location: location)
    }
}
