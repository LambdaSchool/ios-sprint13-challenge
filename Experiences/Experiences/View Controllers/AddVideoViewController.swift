//
//  AddVideoViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class AddVideoViewController: UIViewController {
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    var name: String? {
        didSet {
            title = name
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    // MARK: - IBActions
    @IBAction func recordVideo(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "saveFullExperienceSegue", sender: self)
    }
    
    // MARK: - View Methods
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

}
