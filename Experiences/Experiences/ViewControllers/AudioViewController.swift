//
//  AudioViewController.swift
//  Experiences
//
//  Created by Shawn James on 6/5/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioSaveDelegate {
    func returnAudioToSaveScreen(audio: URL)
}

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var soundRecorder: AVAudioRecorder?
    var soundPlayer: AVAudioPlayer?
    var fileName: String = "recording.m4a"
    var audioFilePath = URL(string: "https://www.google.com")!
    var audioSaveDelegate: AudioSaveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFilePath = getDocumentsDirectory().appendingPathComponent(fileName)
        setupRecorder()
        setupPlayer()
        setupTimer()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    private func setupRecorder() {
//        let audioFilePath = getDocumentsDirectory().appendingPathComponent(fileName)
        playPauseButton.isEnabled = false
        let recordSettings: [String : Any] = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.0] as [String : Any]
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilePath, settings: recordSettings)
            soundRecorder?.delegate = self
            soundRecorder?.prepareToRecord()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupPlayer() {
//        let audioFilePath = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilePath)
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
        } catch {
            print(error)
        }
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressBar() {
        progressBar.progress = Float(0)
        if let soundPlayer = soundPlayer {
            progressBar.progress = Float(soundPlayer.currentTime / soundPlayer.duration)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playPauseButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playPauseButton.setTitle("Play", for: .normal)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if recordButton.titleLabel?.text == "Record" {
            soundRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
            playPauseButton.isEnabled = false
        } else {
            soundRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            playPauseButton.isEnabled = false
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if playPauseButton.titleLabel?.text == "Play" {
            playPauseButton.setTitle("Stop", for: .normal)
            playPauseButton.isEnabled = false
            setupPlayer()
            soundPlayer?.play()
        } else {
            soundPlayer?.stop()
            playPauseButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = false
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        audioSaveDelegate?.returnAudioToSaveScreen(audio: self.audioFilePath)
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
