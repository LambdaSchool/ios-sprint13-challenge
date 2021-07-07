//
//  Player.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import Foundation
import AVFoundation


protocol PlayerDelegate: AnyObject {
    func playerDidChangeState(_ player: Player)
}

class Player: NSObject {

    weak var delegate: PlayerDelegate?

    // Adding Audio is Optional
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }

    var elapsedTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }

    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }

    func play(urlFile: URL? = nil) {

        guard let file = urlFile else { return }

        audioPlayer = try! AVAudioPlayer(contentsOf: file)
        audioPlayer?.delegate = self
        audioPlayer?.play()
        notifyDelegate()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.pause()
        notifyDelegate()

    }

    func playPause(urlFile: URL? = nil) {

        if isPlaying {
            pause()
        } else {
            play(urlFile: urlFile)
        }

    }

    private func notifyDelegate() {
        delegate?.playerDidChangeState(self)
    }



}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        notifyDelegate()
    }
}
