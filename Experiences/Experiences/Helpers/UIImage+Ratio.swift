//
//  UIImage+Ratio.swift
//  Experiences
//
//  Created by Morgan Smith on 9/14/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//


import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
