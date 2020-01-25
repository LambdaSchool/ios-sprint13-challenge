//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Bobby Keffury on 1/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ExperienceViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    //MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Methods
    
    //MARK: - Actions
    
    @IBAction func saveTapped(_ sender: Any) {
        performSegue(withIdentifier: "saveSegue", sender: self)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
    }
    
    @IBAction func recordTapped(_ sender: Any) {
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
