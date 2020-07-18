//
//  UIImage+Flattened.swift
//  Experiences
//
//  Created by Chad Parker on 2020-07-18.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Renders the image if the pixel data was rotated due to orientation of camera
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
            draw(at: .zero)
        }
    }
}
