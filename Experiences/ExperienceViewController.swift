//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Kenneth Jones on 11/16/20.
//

import UIKit

class ExperienceViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var expController: ExperienceController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveExperience(_ sender: Any) {
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
    }
}
