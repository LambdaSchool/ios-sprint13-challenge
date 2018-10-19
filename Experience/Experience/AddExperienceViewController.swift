//
//  AddExperienceViewController.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import AVFoundation

class AddExperienceViewController: UIViewController, AVAudioPlayerDelegate
{
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var audioRecordingButton: UIButton!
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    @IBAction func addImage(_ sender: Any)
    {
        
    }
    
    @IBAction func addAudio(_ sender: Any)
    {
        let isRecording = recorder?.isRecording ?? false
        if isRecording
        {
            recorder?.stop()
            if let url = recorder?.url {
                player = try! AVAudioPlayer(contentsOf: url)
                player?.delegate = self
            }
        }
        else
        {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
            recorder = try! AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
        }
        updateViews()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        updateViews()
    }
    
    private func updateViews()
    {
        guard isViewLoaded else {return}
        
        let isRecording = recorder?.isRecording ?? false
        let recordButtonTitle = isRecording ? "Stop Recording" : "Add Audio Recording"
        audioRecordingButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    private func newRecordingURL() -> URL
    {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowAddVideo"
        {
            let addVideoView = segue.destination as! AddVideoViewController
            
        }
    }
    
    private func showCamera()
    {
        performSegue(withIdentifier: "ShowAddVideo", sender: nil)
    }
    
    private func getPermission()
    {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.showCamera()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if !granted {fatalError("VideoFilters needs camera access")}
                self.showCamera()
            }
        case .denied:
            fallthrough
        case .restricted:
            fatalError("VideoFilters needs camera access")
        }
    }

}
