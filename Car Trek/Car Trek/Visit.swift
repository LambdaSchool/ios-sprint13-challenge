//
//  Visit.swift
//  Car Trek
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit

class Visit {
    var name: String
    var location: Int
    var photo: UIImage?
    var audioRecordingURL: URL?
    var videoRecordingURL: URL?
    
    init(name: String, location: Int, photo: UIImage?, audioURL: URL?, videoURL: URL?) {
        self.name = name
        self.location = location
        self.photo = photo
        self.audioRecordingURL = audioURL
        self.videoRecordingURL = videoURL
    }
}
