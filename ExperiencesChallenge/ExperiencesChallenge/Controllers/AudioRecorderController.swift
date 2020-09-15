//
//  AudioRecorderController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//



import Foundation
import AVFoundation

class AudioRecorderController: NSObject {


    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?

    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }

    func record() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])

        let file = documents.appendingPathComponent(name).appendingPathExtension("caf")
        recordingURL = file

        print("record: \(file)")


        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!

        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }

    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
    }

    func recordToggle() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
}

extension AudioRecorderController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recorder error: \(error)")
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        print("Finished Recording")
    }
}
