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
    
    static let shared = ExperienceController()
    
    var experiences: [Experience] = []
    var postTitle: String?
    var description: String?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    
   
    func createExperience(with title: String?,
                          description: String?,
                          image: UIImage?,
                          audioURL: URL?,
                          videoURL: URL?,
                          timestamp: Date = Date()) {
        let experience = Experience(title: postTitle ?? "",
                                    description: description ?? "",
                                    image: image ?? nil,
                                    audioURL: audioURL ?? nil,
                                    videoURL: videoURL ?? nil,
                                    timestamp: Date())
        self.experiences.append(experience)
        return
    }
}
