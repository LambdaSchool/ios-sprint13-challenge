//
//  AudioRecorderController.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderController {
    // MARK: - Properties
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.isMeteringEnabled = true
        }
    }
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    // MARK: - Playback
    
//    var isPlaying: Bool {
//        audioPlayer?.isPlaying ?? false
//    }
//
//    func loadAudio() {
//        let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
//        } catch {
//            preconditionFailure("Failure to load audio file \(error)")
//        }
//    }
//
//    func prepareAudioSession() throws {
//        let session = AVAudioSession.sharedInstance()
//        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
//        try session.setActive(true, options: []) // can fail if on a phone call, for instance
//    }
//
//    func play() {
//        do {
//            try prepareAudioSession()
//            audioPlayer?.play()
//            updateViews()
//            startTimer()
//        } catch {
//            print("Cannot play audio: \(error)")
//        }
//    }
//
//    func pause() {
//        audioPlayer?.pause()
//        updateViews()
//        cancelTimer()
//    }
    
    
    // MARK: - Recording
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")

//        print("recording URL: \(file)")

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

        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }

    func startRecording() {
        recordingURL = createNewRecordingURL()

        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format): \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
//
//    // MARK: - Actions
//
//    @IBAction func togglePlayback(_ sender: Any) {
//        if isPlaying {
//            pause()
//        } else {
//            play()
//        }
//    }
//
//    @IBAction func updateCurrentTime(_ sender: UISlider) {
//        if isPlaying {
//            pause()
//        }
//
//        audioPlayer?.currentTime = TimeInterval(sender.value)
//        updateViews()
//    }
//
    
}
