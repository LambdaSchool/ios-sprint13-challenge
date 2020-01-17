//
//  AudioRecorderControl.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-14.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Delegate

protocol AudioRecorderControlDelegate: AnyObject {
    func audioRecorderControl(
        _ recorderControl: AudioRecorderControl,
        didFinishRecordingSucessfully didFinishRecording: Bool)
}

@IBDesignable
class AudioRecorderControl: UIControl {

    // MARK: - UI Elements

    private var recordButton = UIButton(type: .system)
    private var timestampLabel = UILabel()

    private var stackView: UIStackView!

    private var timeFormatter: DateComponentsFormatter {
        DateComponentsFormatter.audioTimeFormatter
    }

    // MARK: - Audio Properties

    private(set) var audioFileURL: URL?

    var isRecording: Bool { audioRecorder?.isRecording ?? false }
    var elapsedTime: TimeInterval { audioRecorder?.currentTime ?? 0 }
    var audioData: Data? {
        guard let url = audioFileURL else { return nil }
        do {
            return try Data(contentsOf: url)
        } catch {
            print("error getting audio data from url: \(error)")
            return nil
        }
    }

    private var audioRecorder: AVAudioRecorder?
    private var uiUpdateTimer: Timer?

    weak var delegate: AudioRecorderControlDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubViews()
    }

    // MARK: - UI Actions

    @objc
    private func recordButtonPressed(_ sender: Any) {
        toggleRecord()
    }

    // MARK: - Recording API

    func toggleRecord() {
        isRecording ? stop() : record()
    }

    func record() {
        guard
            let docs = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first,
            let format = AVAudioFormat(standardFormatWithSampleRate: 44_100,
                                       channels: 1)
            else {
                print("Cannot record; missing docs folder!")
                return
        }
        let name = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .autoupdatingCurrent,
            formatOptions: [.withInternetDateTime])
        let file = docs.appendingPathComponent(name).appendingPathExtension("caf")
        audioFileURL = file
        print("recording to file: \(file)")

        do {
            let recorder = try AVAudioRecorder(url: file, format: format)
            recorder.delegate = self
            recorder.record()
            audioRecorder = recorder
        } catch {
            print("error setting up audio recorder: \(error)")
        }
        updateViews()
        startUIUpdateTimer()
    }

    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
    }

    func clearData() {
        stop()
        audioRecorder?.deleteRecording()
        let fm = FileManager.default
        if let url = audioFileURL,
            fm.isDeletableFile(atPath: url.path) {
            try? fm.trashItem(at: url, resultingItemURL: nil)
        }
        self.audioFileURL = nil
    }

    // MARK: - Helper Methods

    private func updateViews() {
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
        timestampLabel.text = timeFormatter.string(from: elapsedTime)
    }

    private func startUIUpdateTimer() {
        killUIUpdateTimer()
        uiUpdateTimer = Timer.scheduledTimer(
            timeInterval: 0.03,
            target: self,
            selector: #selector(updateUITimer(_:)),
            userInfo: nil,
            repeats: true)
    }

    private func killUIUpdateTimer() {
        uiUpdateTimer?.invalidate()
        uiUpdateTimer = nil
    }

    @objc
    private func updateUITimer(_ timer: Timer) {
        updateViews()
    }

    private func setUpSubViews() {
        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(
            self,
            action: #selector(recordButtonPressed(_:)),
            for: .touchUpInside)

        stackView = UIStackView(arrangedSubviews: [
            recordButton,
            timestampLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)])

        updateViews()
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorderControl: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finished recording")
        updateViews()
        delegate?.audioRecorderControl(self, didFinishRecordingSucessfully: flag)
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("error with audio recorder: \(error)")
        }
    }
}
