//
//  UIImage+Ratio.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
