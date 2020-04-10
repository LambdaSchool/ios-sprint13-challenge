//
//  PostViewController.swift
//  SprintChallenge
//
//  Created by Elizabeth Wingate on 4/10/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    var experienceController: ExperienceController?
    
    @IBOutlet var titleTextField: UITextField!
     @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
         print("addPosterButtonPressed")
     }

     @IBAction func recordButtonPressed(_ sender: Any) {
         print("recordButtonPressed")
     }
    
    @objc func back() {
         dismiss(animated: true, completion: nil)
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
