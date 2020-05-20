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
    var visit: Visit?
    
    var visitDelegate: VisitDelegate?
    var audioIsPlaying: Bool = false
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateViews()
    }
    
    func updateViews() {
        // TODO: fix to update with all properties correctly
        guard let visit = visit else { return }
        let name = visit.name
        nameTextField.text = name
        
        if let photo = visit.photo {
        photoImageView.image = photo
        }
        
        audioElapsedTimeLabel.text = "0:00"
        audioTotalTimeLabel.text = "0:00"
        updateSlider()
        
        if audioIsPlaying {
            audioPlayButton.title(for: .selected)
        } else {
            audioPlayButton.title(for: .normal)
        }
    }
    
    func updateSlider() {
        
    }
    
    // MARK: - Actions
    @IBAction func addPhoto(_ sender: UIButton) {
        
    }
    
    @IBAction func addAudioRecording(_ sender: UIButton) {
        
    }
    
    @IBAction func addVideoRecording(_ sender: UIButton) {
        
    }
    
    @IBAction func saveVisit(_ sender: UIBarButtonItem) {
        if visit == nil {
        guard let name = nameTextField.text/*, let location = location */ else {
            print("Need to add a name.")
            return
        }
        // TODO: Fix location to be current locaton, and URLs to reflect correct URL path.
        let audioURL = URL(fileURLWithPath: "")
        let videoURL = URL(fileURLWithPath: "")
        let newVisit: Visit = Visit(name: name, location: 0, photo: photoImageView.image, audioURL: audioURL, videoURL: videoURL)
        visitDelegate?.saveNew(visit: newVisit)
        navigationController?.popViewController(animated: true)
        } else {
            guard let name = nameTextField.text/*, let location = location */, let visit = visit else {
                print("Need to add a name.")
                return
            }
            
            let audioURL = URL(fileURLWithPath: "")
            let videoURL = URL(fileURLWithPath: "")
            let image = photoImageView.image
            //let indexPath = visits.
            visit.name = name
            visit.audioRecordingURL = audioURL
            visit.videoRecordingURL = videoURL
            visit.photo = image
            //visitDelegate?.update(visit: visit, indexPath: indexPath)
        }
    }
}

protocol VisitDelegate {
     func saveNew(visit: Visit)
     func update(visit: Visit, indexPath: IndexPath)
}
