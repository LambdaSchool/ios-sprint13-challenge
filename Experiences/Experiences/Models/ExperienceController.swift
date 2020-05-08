//
//  PostController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class ExperienceController {
    var experiences: [Experience] = []
    var postTitle: String?
    var description: String?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    
    func createExperience(with title: String, description: String? = "", image: UIImage? = nil, audioURL: URL? = nil, videoURL: URL? = nil, timestamp: Date = Date()) {
        if let postTitle = postTitle {
        let experience = Experience(title: postTitle, description: description, image: image, audioURL: audioURL, videoURL: videoURL, timestamp: Date())
        self.experiences.append(experience)
        return
        }
    }
}
