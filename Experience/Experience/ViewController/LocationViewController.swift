//
//  LocationViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var location: Location?
    
    @IBOutlet weak var locationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        location = .current
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveLocationTapped(_ sender: Any) {
        guard let locationText = locationTextField.text, !locationText.isEmpty else {return}
        location = .other
        navigationController?.popViewController(animated: true)
    }
}
