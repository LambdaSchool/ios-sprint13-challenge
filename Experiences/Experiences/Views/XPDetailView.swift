//
//  XPView.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import AVFoundation

class XPDetailView: UIView {

    var experience: Experience? {
        didSet {
            updateSubviews()
        }
    }
    
    var imageView = UIImageView()
    var sliderView = UISlider()
    var playButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.setImage(UIImage(systemName: "stop.fill"), for: .selected)
        playButton.setTitle("", for: .normal)
        playButton.addTarget(self, action: #selector(togglePlayback(_:)), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sliderView)
        playButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        playButton.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sliderView.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sliderView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        sliderView.value = 0
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private Methods
    
    private func updateSubviews() {
        imageView.image = experience?.image
        
        if let audioURL = experience?.audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        } else {
            sliderView.isHidden = true
            playButton.isHidden = true
        }
    }
    
    @objc func togglePlayback(_ sender: Any) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    var audioPlayer: AVAudioPlayer? {
        didSet {
            // Using a didSet allows us to make sure we don't forget to set the delegate
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
        }
    }
    
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }




    // Fixes bug for iPhone
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }


    func play() {
        audioPlayer?.play()
        startTimer()
//        updateViews()
    }

    func pause() {
        audioPlayer?.pause()
        cancelTimer()
        updateViews()
    }



    // MARK: - Timer
    var timer: Timer?

    func startTimer() {
        timer?.invalidate() // Cancel a timeer before you start a new one

        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }

            self.updateViews()

        }
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateViews(){
        playButton.isSelected = isPlaying
    }


}

extension XPDetailView: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("⚠️ Audio Player Error: \(error)")
        }
        updateViews()
    }
}
