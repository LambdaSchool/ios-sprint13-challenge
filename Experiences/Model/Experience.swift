//
//  Experience.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import AVKit

class Experience: NSObject {
    
    var id: String = UUID().uuidString
    var experienceName: String
    var audioMemory: AVAudioFile?
    var videoMemoryURL: URL?
    var experienceImage: UIImage?
    var location: CLLocationCoordinate2D
    var experienceDate: String = Date().fullDate
    var experienceTime: String = Date().shortTime
    
 
    init(experienceName: String, audioMemory: AVAudioFile?, videoMemoryURL: URL?, experienceImage: UIImage?, location: CLLocationCoordinate2D) {
        self.experienceName = experienceName
        self.audioMemory = audioMemory
        self.videoMemoryURL = videoMemoryURL
        self.experienceImage = experienceImage
        self.location = location
    }
    
    // so we can see the contents of the NSObject instead of its memory address
    override var description: String {
        get {
            return "Experience( id: \(self.id), experienceName: \(self.experienceName), audioMemory: \(self.audioMemory), videoMemoryURL: \(self.videoMemoryURL),  experienceImage: \(self.experienceImage), location: \(self.location), experienceDate: \(self.experienceDate), experienceTime: \(self.experienceTime)"
        }
    }
}
    

//Quick and Dirty dataSource for experiences.
//FIXME: - Add persistence later.
struct Experiences {
    static var experiences: [Experience] = []
}
