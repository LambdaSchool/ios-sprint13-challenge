//
//  UIImage+Ratio.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
