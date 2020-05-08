//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import CoreLocation

class AddExperienceViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var recordAudioButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    // MARK: - Properties
    let locationManager = CLLocationManager()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - IBActions
    
    @IBAction func recordAudioButtoTapped(_ sender: Any) {
    }
    
    
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
