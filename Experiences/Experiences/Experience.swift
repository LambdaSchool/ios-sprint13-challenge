//
//  Experience.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit


class Experience: NSObject {
    var audio: URL
    var video: URL 
    var image: UIImage
    var title: String

    init(audio: URL, video: URL, image: UIImage, title: String) {
        self.audio = audio
        self.video = video
        self.image = image
        self.title = title
    }
}
