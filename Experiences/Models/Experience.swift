//
//  Experience.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Experience: NSObject {
    var video: URL?
    var image: UIImage?
    var title: String?
    var note: String?
    var audio: URL?
    var geotag: CLLocationCoordinate2D?
    
    required init(video: URL?, image: UIImage?, title: String, note: String?, audio: URL?, geotag: CLLocationCoordinate2D?) {
        self.title = title
        self.note = note
        self.video = video
        self.image = image
        self.audio = audio
        self.geotag = geotag
        
        super.init()
    }
}
