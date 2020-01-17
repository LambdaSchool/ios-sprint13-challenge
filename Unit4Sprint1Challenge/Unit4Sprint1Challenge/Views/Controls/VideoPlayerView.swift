//
//  VideoPreviewView.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-15.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView {

    private(set) var isPlaying: Bool = false
    var videoIsLoaded: Bool {
        player != nil && looper != nil
    }

    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    // MARK: - Init/Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        // add tap gesture to replay video (repeat loop?)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(viewTapped(_:)))
        addGestureRecognizer(tapGesture)
        playerLayer.bounds = frame
        self.playerLayer.videoGravity = .resizeAspect
    }

    deinit {
        self.player?.pause()
        self.player = nil
    }

    // MARK: - API

    func togglePlaying() {
        isPlaying ? pause() : play()
    }

    func play() {
        guard let player = player else { return }
        player.play()
        isPlaying = true
    }

    func pause() {
        guard let player = player else { return }
        player.pause()
        isPlaying = false
    }

    func loadVideo(url: URL) {
        setUpPlayer(with: AVPlayerItem(url: url))
    }

    func loadVideo(data: Data) throws {
        let url: URL = .newLocalVideoURL()
        try data.write(to: url)
        setUpPlayer(with: AVPlayerItem(url: url))
    }

    func unloadVideo() {
        pause()
        looper?.disableLooping()
        looper = nil
        player = nil
    }

    // MARK: - Helpers

    @objc
    func viewTapped(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .ended {
            togglePlaying()
        }
    }

    private func setUpPlayer(with item: AVPlayerItem) {
        let newPlayer = AVQueuePlayer(playerItem: item)
        playerLayer.player = newPlayer
        // TODO: customize rectangle bounds?

        looper = AVPlayerLooper(player: newPlayer, templateItem: item)
        player = newPlayer
    }
}
