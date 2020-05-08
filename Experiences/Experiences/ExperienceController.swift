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
    func create(title: String?, audioClip: URL?, image: URL?, videoClip: URL?) {
        let exp = Experience()

        exp.title = title
        exp.audioClip = audioClip
        exp.image = image
        exp.videoClip = videoClip

        // FIXME: Add GPS
        //        var latitude: Double?
        //        var longitude: Double?

        experiences.append(exp)
    }

    // Read

    // Update

    // Delete

}
