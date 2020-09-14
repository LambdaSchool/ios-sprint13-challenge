//
//  Experience.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {

    //This is whatever the user decides to call the experience
    let experienceTitle: String

    //This is the image the user chooses for the experience
    let image: UIImage

    //The URL will contain the audio recording
    let audioRecordingURL: URL
    
    
    //MKAnnotation properties
    var coordinate: CLLocationCoordinate2D
    var title: String? {
        return experienceTitle
    }
    var subtitle: String? {
        return "idk what to put here..."
    }

    init(experienceTitle: String, image: UIImage, audioRecordingURL: URL, coordinate: CLLocationCoordinate2D) {
        self.experienceTitle = experienceTitle
        self.image = image
        self.audioRecordingURL = audioRecordingURL
        self.coordinate = coordinate
    }
    
}
