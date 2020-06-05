//
//  Experience.swift
//  stuff
//
//  Created by Alex Thompson on 5/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

import MapKit

class Experience: NSObject {
    
    var experienceTitle: String
    var geotag: CLLocationCoordinate2D
    var picture: Picture
    var video: Video
    var audio: Audio
    
    init(experienceTitle: String,
         geotag: CLLocationCoordinate2D,
         picture: Picture,
         video: Video,
         audio: Audio) {
        
        self.experienceTitle = experienceTitle
        self.geotag = geotag
        self.picture = picture
        self.video = video
        self.audio = audio
        
    }
    
    struct Picture {
        var imagePost: UIImage
        
        init(imagePost: UIImage) {
            self.imagePost = imagePost
        }
    }
    
    struct Video {
        var videoPost: URL
        
        init(videoPost: URL) {
            self.videoPost = videoPost
        }
    }
    
    struct Audio {
        var audioPost: URL
        
        init(audioPost: URL) {
            self.audioPost = audioPost
        }
    }
    
    struct Time {
        var time: Date
        
        init(time: Date) {
            self.time = time
        }
    }
}
