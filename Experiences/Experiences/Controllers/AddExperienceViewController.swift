//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Joe on 5/18/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MapKit
import AVKit

class AddExperienceViewController: UIViewController {
    
    @IBOutlet weak var newItemTitleField: UITextField!
    @IBOutlet weak var addPosterButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var xpDelegate: XPs?
    
    //MARK: Internal Properties
    var imagePickedBlock: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    //MARK: - Actions
    @IBAction func addPosterButtonPressed(_ sender: Any) {
        if imageView.image == nil {
            presentPicker(type: .photoLibrary)
        } else {
            guard let image = imageView.image else { return }
            makeBlackandWhite(photo: image)
        }
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    //saves photo to struct
    func save(photo: UIImage) {
        xpDelegate?.photo = photo
        DispatchQueue.main.async {
            self.imageView.image = photo
            self.addPosterButton.setTitle("Black and White", for: .normal)
            self.imageView.isHidden = false
        }
    }
    
    func save(video: URL) {
        xpDelegate?.video = video
        }    
}



