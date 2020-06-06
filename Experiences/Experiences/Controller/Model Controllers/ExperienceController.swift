//
//  ExperienceController.swift
//  Experiences
//
//  Created by Kenny on 6/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class ExperienceController {
    // MARK: - Singleton -
    static var shared = ExperienceController()
    private init() { }

    private var experiences: [ExperienceProtocol] = []

    var photoExperiences: [PhotoExperience] {
        var photoExperiences: [PhotoExperience] = []
        for experience in experiences {
            if experience is PhotoExperience {
                photoExperiences.append(experience as! PhotoExperience)
            }
        }
        return photoExperiences
    }

    var storyExperiences: [Experience] {
        var storyExperiences: [Experience] = []
        for experience in experiences {
            if experience is Experience {
                storyExperiences.append(experience as! Experience)
            }
        }
        return storyExperiences
    }

    var videoExperiences: [VideoExperience] {
        var videoExperiences: [VideoExperience] = []
        for experience in experiences {
            if experience is VideoExperience {
                videoExperiences.append(experience as! VideoExperience)
            }
        }
        return videoExperiences
    }

    var count: Int {
        experiences.count
    }

    func append(_ storyExperience: Experience) {
        experiences.append(storyExperience)
    }

    func append(_ photoExperience: PhotoExperience) {
        experiences.append(photoExperience)
    }

    func append(_ videoExperience: VideoExperience) {
        experiences.append(videoExperience)
    }

    func remove(with id: UUID) {
        experiences.removeAll {
            $0.id == id
        }
    }

    func getStoryExperience(with id: UUID) -> Experience? {
        return storyExperiences.first(where: { $0.id == id })
    }

    func getPhotoExperience(with id: UUID) -> PhotoExperience? {
        return photoExperiences.first(where: { $0.id == id })
    }

    func getVideoExperience(with id: UUID) -> VideoExperience? {
        return videoExperiences.first(where: { $0.id == id })
    }
}
