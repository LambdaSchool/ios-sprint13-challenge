//
//  ExperienceController.swift
//  Experiences
//
//  Created by Jonathan Ferrer on 7/12/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import MapKit
import CoreLocation

class ExperienceController: NSObject, CLLocationManagerDelegate {

    var experiences: [Experience] = []

    func createExperience(title: String, image: UIImage, audioURL: URL, videoURL: URL, coordinates: CLLocationCoordinate2D) {
        let experience = Experience(title: title, image: image, audioURL: audioURL, videoURL: videoURL, coordinate: coordinates)
        experiences.append(experience)
    }

}

