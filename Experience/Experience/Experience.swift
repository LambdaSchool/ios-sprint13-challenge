//
//  Experience.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var audioURL: URL?
    
    
    // MARK: - Initializers
    
    init(title: String, coordinate: CLLocationCoordinate2D, image: UIImage?, audioURL: URL?) {
        self.title = title
        self.coordinate = coordinate
        self.image = image
        self.audioURL = audioURL
    }
}


class ExperienceController  {
    
    static let shared = ExperienceController()
    var experiences: [MKAnnotation] = []
    
    func addExperence(_ newExperience: Experience) {
        experiences.append(newExperience)
    }
}

