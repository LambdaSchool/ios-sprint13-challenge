//
//  DelegateProtocols.swift
//  ExperiencesWorkingDraft
//
//  Created by Cody Morley on 7/9/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import UIKit

protocol VideoAdderDelegate {
    mutating func addVideo(_ video: URL)
}

protocol PhotoAdderDelegate {
    mutating func addPhoto(_ photo: UIImage)
}

protocol AudioAdderDelegate {
    mutating func addAudio(_ audio: URL)
}
