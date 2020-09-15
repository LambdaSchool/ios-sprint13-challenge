//
//  UIImage+Ratio.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
