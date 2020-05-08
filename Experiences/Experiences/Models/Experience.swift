//
//  Experience.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVKit

class Experience: NSObject {
    // MARK: - Properties
    var name: String
    var title: String? {
        name
    }
    var info: String
    override var description: String {
        info
    }
    var image: UIImage?
    var video: AVMovie?
    var audio: AVAudioFile?
    let latitude: Double
    let longitude: Double
    let time: Date
    
    // MARK: - Initializers
    internal init(name: String,
                  info: String,
                  image: UIImage? = nil,
                  video: AVMovie? = nil,
                  audio: AVAudioFile? = nil,
                  latitude: Double,
                  longitude: Double,
                  time: Date) {
        self.name = name
        self.info = info
        self.image = image
        self.video = video
        self.audio = audio
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Codingkeys.self)
//        let geotag = try container.nestedContainer(keyedBy: Codingkeys.self, forKey: .geotag)
//
//        self.title = try container.decode(String.self, forKey: .title)
//        self.info = try container.decode(String.self, forKey: .info)
//        self.image = try container.decodeIfPresent(UIImage.self, forKey: .image)
//        self.video = try container.decodeIfPresent(AVMovie.self, forKey: .video)
//        self.audio = try container.decodeIfPresent(AVAudioFile, forKey: .audio)
//        self.latitude = try geotag.decode(Double.self, forKey: .latitude)
//        self.longitude = try geotag.decode(Double.self, forKey: .longitude)
//        self.time = try container.decode(Date.self, forKey: .time)
//    }
//
//    enum Codingkeys: String, CodingKey {
//        case title = "title"
//        case info = "info"
//        case image = "image"
//        case video = "video"
//        case audio = "audio"
//        case geotag = "geotag"
//        case latitude = "latitude"
//        case longitude = "longitude"
//        case time = "time"
//
//
//    }
}
