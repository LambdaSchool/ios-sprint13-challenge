//
//  NewXperiencePostViewController.swift
//  11-7-20 iosLambdaExperiencesSprintChallenge
//
//  Created by BrysonSaclausa on 11/7/20.
//

import UIKit

class NewXperiencePostViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    
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
    
    //MARK:- FUNCTIONS
    
    private func presentImagePickerController() {
        
   }
    
    //MARK: - IBACTIONS
    
    @IBAction func chooseAnImageTapped(_ sender: Any) {
        presentImagePickerController()
    }
    @IBAction func addARecordingTapped(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
}
