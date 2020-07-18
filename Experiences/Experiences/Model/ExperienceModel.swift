//
//  ExperienceModel.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct Image {
    var title: String
    var image: URL
}

struct Recording {
    var title: String
    var audioRecording: URL
    var timeLength: String
}

struct MapPost {
    var timestamp: Date
    var url: URL
    var comment: String
}

struct Experience {
    var title: String
    var audioURL: URL?
    var imageURL: URL?
    var videoURL: URL?
}
