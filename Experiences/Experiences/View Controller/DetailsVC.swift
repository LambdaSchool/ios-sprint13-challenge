//
//  DetailsVC.swift
//  Experiences
//
//  Created by Norlan Tibanear on 11/16/20.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        return result
    }()
    
    
    // Properties
    var experience: Experience?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureMapView()
    }
    
    func configureView() {
        guard let experience = experience else { return }
        titleLabel.text = experience.title
        
        
        if let image = experience.image {
            imageView.image = image
        }
        
        dateLabel.text = dateFormatter.string(from: experience.timestamp)
        
    }//
    
    func configureMapView() {
        guard let experience = experience else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let coordinateRegion = MKCoordinateRegion(center: experience.coordinate, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(experience)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playMessageSegue" {
            let message = segue.destination as! AudioVC
            message.recordingURL = experience?.audio
            message.playOnlyMode = true
        }
    }

}//
