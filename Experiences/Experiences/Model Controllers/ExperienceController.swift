//
//  ExperienceController.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import MapKit

class ExperienceController {

    static let shared = ExperienceController()

    var experiences: [Experience] = []

    func createExperience(with title: String, image: UIImage, audioURL: URL? = nil, location: CLLocationCoordinate2D) {

        let experience = Experience(title: title, image: image, audioURL: audioURL, location: location)

        experiences.append(experience)

    }

}
