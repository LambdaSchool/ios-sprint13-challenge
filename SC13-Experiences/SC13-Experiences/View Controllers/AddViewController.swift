//
//  AddViewController.swift
//  SC13-Experiences
//
//  Created by Andrew Dhan on 10/19/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: - IBActions
    
    @IBAction func save(_ sender: Any) {
    }
    @IBAction func addImage(_ sender: Any) {
    }
    @IBAction func recordAudio(_ sender: Any) {
    }
    @IBAction func recordVideo(_ sender: Any) {
    }
    //MARK: - Properties
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordVideoButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
}
