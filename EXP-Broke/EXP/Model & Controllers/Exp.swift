//
//  Exp.swift
//  EXP
//
//  Created by Madison Waters on 2/22/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

//extension Exp: MKAnnotation {
//    return
//}

class Exp: NSObject {
    
    let title: String
    let audio: URL?
    let video: URL?
    let image: UIImage?
    let location: MKAnnotation

    init(title: String, audio: URL? = nil, video: URL? = nil, image: UIImage = UIImage(), location: MKAnnotation){
        self.title = title
        self.audio = audio
        self.video = video
        self.image = image
        self.location = location
    }
   
}
