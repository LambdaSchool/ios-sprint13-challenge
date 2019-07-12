//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Sameera Roussi on 7/12/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Dismiss keyboard after typing in textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    // MARK: Actions
    // Add Poster image button
    @IBAction func addPosterImageButtonTapped(_ sender: Any) {
        let sourceSelect = UIAlertController(title: "Select Source", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        // select the image from the photo library
        let photoLibrarySource = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            // Code to unfollow
        }
        
        // Select the image from the camera
        let cameraSource = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            // Code to unfollow
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sourceSelect.addAction(photoLibrarySource)
        sourceSelect.addAction(cameraSource)
        sourceSelect.addAction(cancelAction)
        self.present(sourceSelect, animated: true, completion: nil)
    }
    
    // Add Record button
    @IBAction func recordButtonTapped(_ sender: Any) {
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
