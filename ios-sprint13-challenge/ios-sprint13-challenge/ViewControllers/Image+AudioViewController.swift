//
//  Image+AudioViewController.swift
//  ios-sprint13-challenge
//
//  Created by De MicheliStefano on 19.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class Image_AudioViewController: UIViewController {

    // MARK: - Navigation
    var experienceController: ExperienceController!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        addImageButton.isHidden = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVideo" {
            guard let videoVC = segue.destination as? VideoViewController else { return }
            videoVC.experienceController = experienceController
        }
    }

}
