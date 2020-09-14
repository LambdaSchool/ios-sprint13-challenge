//
//  UIImage+Ratio.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
