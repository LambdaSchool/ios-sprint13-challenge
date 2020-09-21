//
//  ExperienceDetailViewController.swift
//  Experience
//
//  Created by Lambda_School_Loaner_241 on 9/19/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import UIKit

class ExperienceDetailViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var experience: Experiences? {
        didSet {
            updateViews()
        }
    }
    
    var network: Networking?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
    
    private func updateViews() {
        if let experience = experience {
            textField.text = experience.name
            
        
            
            
        } else {
            
            
        }
        
        
    }
    
    private func createExp(){
     let newExp = Experiences(name: textField.text!, image: "", audio: "", identifier: UUID().uuidString) // initialized
        
        
        
        
        
        
    }
    
    
    // Save to persistent store
    
    
   

}
