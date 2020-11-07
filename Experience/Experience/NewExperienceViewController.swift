//
//  NewExperienceViewController.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import UIKit

class NewExperienceViewController: UIViewController {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
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
