//
//  EntryViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    
    @IBOutlet weak var DescriptionTextField: UITextField!
    
    
    @IBOutlet weak var recordAudioButton: UIButton!
    
    @IBAction func recordAudioTapped(_ sender: UIButton) {
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    
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
