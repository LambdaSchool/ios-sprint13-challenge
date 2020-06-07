//
//  AudioRecorderController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorderController: NSObject {
    var audioRecorder: AVAudioRecorder?
    var recordURL: URL?

    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }

    func record() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])

        let file = documents.appendingPathComponent(name).appendingPathExtension("caf")
        recordURL = file

        print("record: \(file)")

        // 44.1 KHz 44,100 samples per second
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // FIXME: error handling

        audioRecorder = try! AVAudioRecorder(url: file, format: format) // FIXME: try!
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
