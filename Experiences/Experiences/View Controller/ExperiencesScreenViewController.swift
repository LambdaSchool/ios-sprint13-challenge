//
//  ExperiencesScreenViewController.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

protocol NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) -> Void
}

class ExperiencesScreenViewController: UIViewController {

    //MARK: - Properties
    var delegate: NewExperienceDelegate?
    
    //MARK: - IBAOutlet
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBACtion
    @IBAction func addImageButtonPressed(_ sender: Any) {
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
