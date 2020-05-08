//
//  CameraViewViewController.swift
//  Experiences
//
//  Created by Karen Rodriguez on 5/8/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class CameraViewViewController: UIViewController {

    // MARK: - Properties

    // MARK: - Outlets
    @IBOutlet weak var cameraPreView: UIView! // Get it? PreVIEW instead of PreviewView? God I'm so witty
    @IBOutlet weak var playbackView: UIView!
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    @IBAction func recordButtonTapped(_ sender: Any) {
    }

}
