//
//  VisitDetailViewController.swift
//  Road Trip
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit

class VisitDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var audioElapsedTimeLabel: UILabel!
    @IBOutlet var audioTotalTimeLabel: UILabel!
    @IBOutlet var audioSlider: UISlider!
    @IBOutlet var audioPlayButton: UIButton!
    @IBOutlet var videoView: UIView!
    
    // MARK: - Properties
    var visit: Visit? {
        didSet {
            updateViews()
        }
    }
    
    var visits: [Visit]?
    var returnToTableView: (([Visit]) -> Void)?
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent, let visits = visits {
            print("Going back to main view controller")
            returnToTableView?(visits)
        }
    }
    
    func updateViews() {
        
    }
    
    // MARK: - Actions
    @IBAction func addPhoto(_ sender: UIButton) {
        
    }
    
    @IBAction func addAudioRecording(_ sender: UIButton) {
        
    }
    
    @IBAction func addVideoRecording(_ sender: UIButton) {
        
    }
    
    @IBAction func saveVisit(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text/*, let location = location */ else {
            print("Need to add a name.")
            return
        }
        // TODO: Fix location to be current locaton, and URLs to reflect correct URL path.
        let audioURL = URL(fileURLWithPath: "")
        let videoURL = URL(fileURLWithPath: "")
        let newVisit: Visit = Visit(name: name, location: 0, photo: photoImageView.image, audioURL: audioURL, videoURL: videoURL)
        visits?.append(newVisit)
    }
}
