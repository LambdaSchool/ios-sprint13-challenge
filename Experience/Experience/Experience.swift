//
//  Experience.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import Foundation
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


class ExperienceController  {
    
    static let shared = ExperienceController()
    var experiences: [MKAnnotation] = []
    
    func addExperence(_ newExperience: Experience) {
        experiences.append(newExperience)
    }
}


//extension Quake: MKAnnotation {
//
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//
//    var title: String? { place }
//
//    var subtitle: String? { "Magnitude: \(magnitude)" }
//}
