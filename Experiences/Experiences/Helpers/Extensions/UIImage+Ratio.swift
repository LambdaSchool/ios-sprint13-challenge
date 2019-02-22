//
//  UIImage+Ratio.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
