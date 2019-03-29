//
//  CameraViewController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    var audioURL: URL?
    var imageURL: URL?
    var caption: String?
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
}
