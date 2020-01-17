//
//  UIImage+Ratio.swift
//  Experiences
//
//  Created by Percy Ngan on 1/17/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

extension UIImage {
	var ratio: CGFloat {
		return size.height / size.width
	}
}
