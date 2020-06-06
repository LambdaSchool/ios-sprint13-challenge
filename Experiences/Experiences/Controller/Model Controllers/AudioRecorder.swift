//
//  AudioRecorder.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

class AudioRecorder {
    // MARK: - Properties -
    private var timer: Timer?

    var recordingURL: URL?

    var recorder: AVAudioRecorder?

    weak var delegate: AudioRecorderDelegate?

    lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()

    var isRecording: Bool {
        recorder?.isRecording ?? false
    }

    // MARK: - Lifecycle -
    init(delegate: AudioRecorderDelegate) {
        self.delegate = delegate
    }

    deinit {
        cancelTimer()
    }

    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }

    // MARK: - Timer
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            self.delegate?.updateRecordingUI()
        }
    }
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Recording
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")

        print("recording URL: \(file)")

        return file
    }


    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    return
                }

                print("Recording permission has been granted!")
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")

            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })

            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

            delegate?.present(alertController, animated: true, completion: nil)
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
        delegate?.updateRecordingUI()
    }

    func startRecording() {
        startTimer()
        let recordingURL = createNewRecordingURL()

        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        recorder = try? AVAudioRecorder(url: recordingURL, format: audioFormat)
        recorder?.delegate = delegate
        recorder?.record()
        self.recordingURL = createNewRecordingURL()
    }

    func stopRecording() {
        delegate?.updateRecordingUI()
        recorder?.stop()
    }

}

