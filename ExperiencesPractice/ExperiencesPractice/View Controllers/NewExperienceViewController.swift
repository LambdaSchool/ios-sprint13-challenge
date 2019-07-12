//
//  NewExperienceViewController.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/12/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController {

    @IBOutlet weak var experienceTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var audioRecordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        // access photo library
        
        // call filtering after user selection
        
        // updateView() or simply display image here since other things aren't happening
        
    }
    
    func updateViews() {
        
        // display image if returning from image selection
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
