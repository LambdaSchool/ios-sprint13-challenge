//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    

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
    
    @IBAction func choosImageButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
    }
    
}
