//
//  Recorder.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//


    // NO LONGER NEEDED SINCE IT'S BEING CREATED IN THE VIEWCONTROLLER
/*
import Foundation
import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(_ recorder: Recorder)
}

class Recorder: NSObject {

    private var audioRecorder: AVAudioRecorder?
    var delegate: RecorderDelegate?
    var fileURL: URL?

    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }

    func record() {

        // Need a new URL file to record to
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        //fileName with "caf" extension
        let fileName = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])

        fileURL = documents.appendingPathComponent(fileName).appendingPathExtension("caf")

        // Quality Format Setup
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!

        audioRecorder = try! AVAudioRecorder(url: fileURL!, format: format)
        audioRecorder?.record()

        notifyDelegate()

    }

    private func notifyDelegate() {
        delegate?.recorderDidChangeState(self)
    }

    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()

    }

    func toggleRecording() {
        if isRecording {
            stop()

        } else {
            record()
        }
    }
}

extension Recorder: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {

        notifyDelegate()
}

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        notifyDelegate()
    }


}

*/
