//
//  Experience.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class Experience: NSObject {
    var video: URL?
    var image: UIImage?
    var title: String?
    var note: String?
    var latitude: Double
    var longitude: Double
    
    required init(video: URL?, image: UIImage?, title: String, note: String?, latitude: Double, longitude: Double) {
        self.title = title
        self.note = note
        self.video = video
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
}
