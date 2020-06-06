//
//  Image+Ratio.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
