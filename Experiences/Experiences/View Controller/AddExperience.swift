//
//  AddExperience.swift
//  Experiences
//
//  Created by Norlan Tibanear on 11/16/20.
//

import UIKit
import MapKit
import Photos
import CoreLocation

protocol AddExperienceDelegate: AnyObject {
    func addNewExperience()
}


class AddExperience: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var mapView: MKMapView!
    
    
    // Properties

    var image: UIImage?
    var audio: URL?
    var coordinate: CLLocationCoordinate2D?
    fileprivate let manager = CLLocationManager()
    var span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    var currentLocation: CLLocationCoordinate2D?

    weak var delegate: AddExperienceDelegate?
    var experience: Experience?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest // battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    

    
    @IBAction func addAudio(_ sender: Any) {
        
    }
    

    

    @IBAction func addExperience(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let coordinate = self.manager.location?.coordinate else { return }

        let experience = Experience(title: title, coordinate: coordinate)

        if let image = image {
            experience.image = image
        }
        
        if let audio = audio {
            experience.audio = audio
        }

        ExperienceController.shared.experiences.append(experience)
        delegate?.addNewExperience()
        self.dismiss(animated: true, completion: nil)
    }//
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddImageVCSegue" {
            let addImageVc = segue.destination as! AddImageVC
            addImageVc.delegate = self
        } else if segue.identifier == "goToAudioSegue" {
            let audioVC = segue.destination as! AudioVC
            audioVC.delegate = self
        }
    }
    
    
    
}// CLASS


extension AddExperience: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
}






extension AddExperience: addImageDelegate {

    func addImage(image: UIImage) {

        self.imageView.image = image

        self.image = image

    }

}

extension AddExperience: AudioDelegate {
    func addAudio(url: URL) {
        audio = url
    }
    
    
}



    
    



