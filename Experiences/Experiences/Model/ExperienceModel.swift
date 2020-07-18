//
//  ExperienceModel.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct Experience {
    var title: String
    var image: URL
    var audioRecording: Recording
    
    struct Recording {
        var recordingURL: URL
        var timeLength: String
    }
}
