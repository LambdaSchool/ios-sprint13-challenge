//
//  AudioPlayerUIDelegate.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
protocol AudioPlayerUIDelegate: AVAudioPlayerDelegate {
    func updatePlayerUI()
    var recordedURL: URL? { get set }
}
