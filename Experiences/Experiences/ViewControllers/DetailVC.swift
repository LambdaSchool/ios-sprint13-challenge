//
//  DetailVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

class DetailVC: UIViewController {

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var audioButton: UIButton!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var mapView: MKMapView!
    
    var experience: Experience?
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .short
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    @IBAction func playAudio(_ sender: UIButton) {
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
    }
    
    private func updateView() {
        guard let experience = experience else { return }
        title = experience.title
        dateLabel.text = dateFormatter.string(from: experience.timestamp)
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
