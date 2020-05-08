//
//  PostController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(with title: String, description: String? = "", imageData: Data? = nil, audioURL: URL? = nil, videoURL: URL? = nil, timestamp: Date = Date()) {
        let experience = Experience(title: title, description: description, imageData: imageData, audioURL: audioURL, videoURL: videoURL, timestamp: Date())
        self.experiences.append(experience)
        return
    }
}
