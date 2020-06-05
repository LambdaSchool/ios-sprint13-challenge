//
//  ExperienceController.swift
//  Experiences
//
//  Created by Mark Gerrior on 5/8/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import UIKit

class ExperienceController {

    var experiences: [Experience] = []

    // MARK: - CRUD

    // Create
    func create(title: String?,
                audioClip: URL?,
                image: UIImage?,
                videoClip: URL?,
                latitude: Double? = 0.0,
                longitude: Double? = 0.0) {

        print("audioClip URL: \(audioClip?.absoluteString ?? "N/A")")
        print("videoClip URL: \(videoClip?.absoluteString ?? "N/A")")
        print("image: \(image != nil ? "Image attached" : "N/A")")

        let exp = Experience()

        exp.title = title
        exp.audioClip = audioClip
        exp.image = image
        exp.videoClip = videoClip

        exp.latitude = latitude
        exp.longitude = longitude

        experiences.append(exp)
    }

    // Read

    // Update
    func update(experience exp: Experience,
                title: String?,
                audioClip: URL?,
                image: UIImage?,
                videoClip: URL?) {

        exp.title = title
        exp.audioClip = audioClip
        exp.image = image
        exp.videoClip = videoClip
    }

    // Delete

}
