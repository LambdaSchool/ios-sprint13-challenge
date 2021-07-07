//
//  Record.swift
//  LambdaTimeline
//
//  Created by Marlon Raskin on 10/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(_ recorder: Record)
    func recorderDidFinishSavingFile(_ recorder: Record, url: URL)
}

class Record: NSObject {

    // MARK: - Computed & Non-computed properties

    private var audioRecorder: AVAudioRecorder?
    var delegate: RecorderDelegate?
    var timer: Timer?

    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }

    var currentTime: TimeInterval {
        audioRecorder?.currentTime ?? TimeInterval(0.0)
    }

    // MARK: - Init()

    override init() {
        super.init()
    }

    // MARK: - Record functions

    func record() {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let audioCommentURL = docDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!

        do {
            audioRecorder = try AVAudioRecorder(url: audioCommentURL, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            startTimer()
        } catch {
            NSLog("Error recording audio or finding url: \(error)")
        }
        notifyDelegate()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer(timeInterval: 0.01, repeats: true, block: { _ in
            self.notifyDelegate()
        })
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }


    func stop() {
        audioRecorder?.stop()
        stopTimer()
        notifyDelegate()
    }

    func toggleRecord() {
        isRecording ? stop() : record()
    }

    // MARK: - Notify

    func notifyDelegate() {
        delegate?.recorderDidChangeState(self)
    }
}

extension Record: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("audioRecorderEncodeErrorDidOccur: \(error)")
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording")
        delegate?.recorderDidFinishSavingFile(self, url: recorder.url)
    }
}
