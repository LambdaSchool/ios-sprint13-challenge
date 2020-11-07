//
//  DetailVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

class DetailVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var audioButton: UIButton!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var mapView: MKMapView!
    
    // MARK: - Properties
    
    var experience: Experience?
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .short
        return result
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAudioSegue" {
            let audioVC = segue.destination as! AudioRecorderVC
            audioVC.recordingURL = experience?.audioURL
            audioVC.playOnlyMode = true
        }
    }
    
    // MARK: - Private Functions
    
    private func updateView() {
        guard let experience = experience else { return }
        title = experience.title
        dateLabel.text = dateFormatter.string(from: experience.timestamp)
        if experience.audioURL != nil {
            audioButton.isHidden = false
        } else {
            audioButton.isHidden = true
        }
        if experience.videoURL != nil {
            videoButton.isHidden = false
        } else {
            videoButton.isHidden = true
        }
        if let image = experience.image {
            imageView.image = image
        }
        setUpMap()
    }
    
    private func setUpMap() {
        guard let experience = experience else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let coordinateRegion = MKCoordinateRegion(center: experience.coordinate, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(experience)
    }
    
}
