//
//  AudioViewController.swift
//  Unit4Sprint1Challenge
//
//  Created by Jon Bash on 2020-01-17.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioVCDelegate: AnyObject {
    func audioVCDidFinishRecording(with data: Data?)
}

class AudioViewController: UIViewController {

    var audioData: Data? { audioRecordererControl.audioData ?? savedAudioData }
    var savedAudioData: Data?

    weak var delegate: AudioVCDelegate?

    // MARK: - Outlets

    @IBOutlet var audioRecordererControl: AudioRecorderControl!
    @IBOutlet var audioPlayerControl: AudioPlayerControl!
    @IBOutlet var reRecordButton: UIButton!

    // MARK: - View Lifecycle / Update

    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecordererControl.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAudio(with: savedAudioData)
        updateViews()
    }

    private func updateViews() {
        guard isViewLoaded else { return }
        let hasRecordedData = (audioData != nil)
        audioRecordererControl.isHidden = hasRecordedData
        audioPlayerControl.isHidden = !hasRecordedData
        reRecordButton.isHidden = !hasRecordedData
    }

    // MARK: - Actions

    @IBAction func reRecordButtonTapped(_ sender: UIButton) {
        clearRecordedData()
    }

    // MARK: - Methods

    func setAudio(with data: Data?) {
        if let audioData = data {
            audioPlayerControl.loadAudio(from: audioData)
        }
    }

    private func clearRecordedData() {
        audioPlayerControl.unloadAudio()
        audioRecordererControl.clearData()
        savedAudioData = nil
        delegate?.audioVCDidFinishRecording(with: nil)
        updateViews()
    }

    private func setUpPlayer() {
        if let data = audioData {
            audioPlayerControl.loadAudio(from: data)
        }
        updateViews()
    }

}

// MARK: - AudioRecorderControlDelegate

extension AudioViewController: AudioRecorderControlDelegate {
    func audioRecorderControl(
        _ recorderControl: AudioRecorderControl,
        didFinishRecordingSucessfully didFinishRecording: Bool
    ) {
        delegate?.audioVCDidFinishRecording(with: recorderControl.audioData)
        setUpPlayer()
    }
}
