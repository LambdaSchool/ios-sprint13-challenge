//
//  Experience.swift
//  Experiences
//
//  Created by Rob Vance on 11/6/20.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    
    let experienceTitle: String
    let image: UIImage
    let audioRecordingURL: URL
    
    var coordinate: CLLocationCoordinate2D
    var title: String? {
        return experienceTitle
    }
    
    init(experienceTitle: String, image: UIImage, audioRecordingURL: URL, coordinate: CLLocationCoordinate2D) {
        self.experienceTitle = experienceTitle
        self.image = image
        self.audioRecordingURL = audioRecordingURL
        self.coordinate = coordinate
    }
}
