//
//  UIImage+NamedAsset.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

extension UIImage {
    enum NamedImage: String {
        case photo
        case story
        case video
    }

    static func withName(_ name: NamedImage) -> UIImage {
        UIImage(named: name.rawValue)!
    }

    // Maybe do this for commonly used images:
    static var photoImage: UIImage {
        withName(.photo)
    }

    static var storyImage: UIImage {
        withName(.story)
    }

    static var videoCamera: UIImage {
        withName(.video)
    }
}
