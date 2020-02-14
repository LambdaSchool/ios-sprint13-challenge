//
//  ExperienceEntry.swift
//  Experiences
//
//  Created by Alex Shillingford on 2/14/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct ExperienceEntry {
    var title, description: String
    var photo: UIImage?
    var movie: AVCaptureOutput?
    var audio: AVAudioFile?
    var id: UUID
}
