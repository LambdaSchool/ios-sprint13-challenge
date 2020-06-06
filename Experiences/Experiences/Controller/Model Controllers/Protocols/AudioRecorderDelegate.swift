//
//  AudioPlayerDelegate.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

protocol AudioRecorderDelegate: AVAudioRecorderDelegate, UIViewController {
    func updateRecordingUI()
}
