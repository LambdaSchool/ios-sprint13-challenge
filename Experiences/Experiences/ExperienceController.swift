//
//  ExperienceController.swift
//  Experiences
//
//  Created by Mark Gerrior on 5/8/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation

class ExperienceController {

    var experiences: [Experience] = []

    // MARK: - CRUD

    // Create
    func create(title: String?,
                audioClip: URL?,
                image: URL?,
                videoClip: URL?,
                latitude: Double? = 0.0,
                longitude: Double? = 0.0) {

//        print("\(audioClip!)")
        
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

    // Delete

}
