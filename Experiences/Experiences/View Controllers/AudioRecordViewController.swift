//
//  AudioRecordViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol AudioRecordViewControllerDelegate: AnyObject {
    func didAddAudioComment(AudioRecordViewController: AudioRecordViewController, audioURL: URL)
}

class AudioRecordViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    // MARK: - Properties

    lazy private var player = AudioPlayer()
    lazy private var recorder = Record()
    var url: URL?

    weak var delegate: AudioRecordViewControllerDelegate?

    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFontForTimeLabels()
        updateSlider()
        player.delegate = self
        recorder.delegate = self
    }

    // MARK: - IBActions

    @IBAction func saveTapped(_ sender: UIButton) {
        guard let audioURL = url else { return }
        send(url: audioURL)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recorder.toggleRecord()
        animateRecordButton()
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        player.playPause()
        updateSlider()
        animatePlayPauseButton()
    }


    // MARK: - Helper Functions

    private func setupUI() {
        playerContainerView.layer.cornerRadius = 12
        playerContainerView.layer.shadowColor = UIColor.black.cgColor
        playerContainerView.layer.shadowRadius = 12
        playerContainerView.layer.shadowOpacity = 0.3
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
    }

    private func updateSlider() {
        slider.minimumValue = 0
        slider.maximumValue = Float(player.duration)
        slider.value = Float(player.currentTime)
    }

    private func updateViews() {
        updateSlider()
        currentTimeLabel.text = timeFormatter.string(from: player.currentTime)
        durationLabel.text = timeFormatter.string(from: player.duration)
    }

    private func animatePlayPauseButton() {
        if player.isPlaying {
            UIView.animateKeyframes(withDuration: 0.8, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.playButton.tintColor = UIColor(red: 0.01, green: 1.00, blue: 0.79, alpha: 1.00)
            }, completion: nil)
        } else {
            playButton.tintColor = .systemTeal
        }
    }

    private func animateRecordButton() {
        if recorder.isRecording {
            UIView.animateKeyframes(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.recordButton.tintColor = .systemPink
            }, completion: nil)
        } else {
            recordButton.tintColor = .systemIndigo
        }
    }

    private func send(url: URL) {
        delegate?.didAddAudioComment(AudioRecordViewController: self, audioURL: url)
    }

    // MARK: - Setup

    func setupFontForTimeLabels() {
        currentTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: currentTimeLabel.font.pointSize, weight: .regular)
        durationLabel.font = UIFont.monospacedDigitSystemFont(ofSize: durationLabel.font.pointSize, weight: .regular)
    }
}

extension AudioRecordViewController: AudioPlayerDelegate {
    func playerDidChangeState(_ player: AudioPlayer) {
        updateViews()
    }
}

extension AudioRecordViewController: RecorderDelegate {
    func recorderDidChangeState(_ recorder: Record) {
        updateViews()
    }

    func recorderDidFinishSavingFile(_ recorder: Record, url: URL) {
        if !recorder.isRecording {
            self.url = url
            print(url)
            do {
                try player.loadAudio(with: url)
            } catch {
                NSLog("Error loading audio with url: \(error)")
            }
        }
    }
}
