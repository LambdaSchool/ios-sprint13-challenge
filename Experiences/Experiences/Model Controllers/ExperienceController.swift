//
//  ExperienceController.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class ExperienceController {

    static let shared = ExperienceController()

    var experiences: [Experience] = []

    func createExperience(with title: String, image: UIImage, audioURL: URL?) {

        let experience = Experience(title: title, mediaType: .image(image), audioURL: audioURL)

        experiences.append(experience)

    }

}
