//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by Joel Groomer on 1/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation

extension Experience {
    convenience init(id: UUID = UUID(), title: String, subtitle: String = "", date: Date = Date(), latitude: Double, longitude: Double, text: String?, audio: URL?, photo: URL?, video: URL?) {
        
        self.init()
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.text = text
        self.audio = audio
        self.photo = photo
        self.video = video
    }
}
