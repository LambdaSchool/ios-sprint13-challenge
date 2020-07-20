//
//  AddExperienceViewController.swift
//  Experiences-Sprint-Challenge
//
//  Created by Matthew Martindale on 7/19/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
        
        // setup photoImage
        let photoImage = UIImage(systemName: "photo", withConfiguration: configuration)
        photoButton.setImage(photoImage, for: .normal)
        
        // setup micImage
        let micImage = UIImage(systemName: "mic.fill", withConfiguration: configuration)
        micButton.setImage(micImage, for: .normal)
    }

}
