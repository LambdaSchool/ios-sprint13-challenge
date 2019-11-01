//
//  CameraViewController.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var recordButton: UIView!
    
    
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

    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
}
