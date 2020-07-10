//
//  Experience.swift
//  Experiences
//
//  Created by Cody Morley on 7/9/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


struct Experience {
    var title: String
    var caption: String?
    var video: URL?
    var photo: UIImage?
    var audio: URL?
    var location: CLLocationCoordinate2D
}
