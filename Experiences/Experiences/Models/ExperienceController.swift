//
//  ExperienceController.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    private var experiences: [Experience] = []
    
    func createExperience(title: String, audioURL: URL, videoURL: URL, imageURL: URL, geotag: CLLocationCoordinate2D? = nil ) {
        let newExperience = Experience(title: title, audioURL: audioURL, videoURL: videoURL, imageURL: imageURL, geotag: geotag)
        experiences.append(newExperience)
        NotificationCenter.default.post(name: .newExperienceNotification, object: self)
    }
    
    func experiencesWithAnnotations() -> Set<Experience> {
        let geotagged = experiences.filter() { $0.geotag != nil }
        return Set(geotagged)
    }
    
}

extension Notification.Name {
    static let newExperienceNotification = Notification.Name(rawValue: "NewExperienceNotification")
}
