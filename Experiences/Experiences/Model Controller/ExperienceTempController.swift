//
//  ExperienceTempController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

class ExperienceTempController {

    public static let shared = ExperienceTempController()

    var experiences: [ExperienceTemp] = []

    func createExperience(title: String, imageURL: URL?, audioURL: URL?, videoURL: URL?, latitude: Double, longitude: Double) {

        let experience = ExperienceTemp(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, latitude: latitude, longitude: longitude)

        experiences.append(experience)
    }

    func updateExperience(experience: ExperienceTemp) {
        guard let index = experiences.firstIndex(of: experience) else { return }
        experiences[index] = experience
    }
}
