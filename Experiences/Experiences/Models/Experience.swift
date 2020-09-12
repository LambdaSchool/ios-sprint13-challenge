//
//  Experience.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

enum MediaType {
    case image(UIImage)
}

class Experience: Equatable {

    let title: String
    let mediaType: MediaType
    var id: String?
    var audioURL: URL?

    init(title: String, mediaType: MediaType, audioURL: URL?) {
        self.title = title
        self.mediaType = mediaType
        self.audioURL = audioURL
        self.id = UUID().uuidString
    }

    static func ==(lhs: Experience, rhs: Experience) -> Bool {
        return lhs.id == rhs.id
    }

}

