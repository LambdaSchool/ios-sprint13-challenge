//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - IBActions
    
    @IBAction func nextExperienceVCButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func getImageButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func recordAudioButtonClicked(_ sender: Any) {
        
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var experienceTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var getImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    
}
