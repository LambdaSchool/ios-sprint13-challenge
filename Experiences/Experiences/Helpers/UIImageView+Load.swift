//
//  UIImageView+Load.swift
//  Experiences
//
//  Created by Joel Groomer on 1/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(from url: URL) {
        guard let imageData = FileManager.default.contents(atPath: url.absoluteString) else {
            self.image = UIImage(named: "Sad-Little-Cloud")
            return
        }
        self.image = UIImage(data: imageData)
    }
}
