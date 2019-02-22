
import Foundation
import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(_ recorder: Recorder)
}

class Recorder: NSObject {
    
    // We are not going to implement pausing of a recording, so once I stop the audio recorder, I can not resume it again
    
    private var audioRecorder: AVAudioRecorder?
    
    // Only the recorder is allowed to set it, but other people can read it (they are reading where the recording is writing to)
    private(set) var currentFile: URL?
    
    weak var delegate: RecorderDelegate?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func toggleRecording() {
        // similar to playPause method
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    func record() {
        
        // Need to create a new url - use the file manager
        let fm = FileManager.default
        // this gets me to the folder
        let docs = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // Make a name for this file - pick a name taht reflects when we're starting to record
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        // Where do I want to save this file? Use that name and the ".caf" extension
        let file = docs.appendingPathComponent(name).appendingPathExtension("caf")
        
        // sample rate: how many times per second is this audio data going to contain a piece of information
        // sample at 44.1khz on a single channel (ie, "mono" audio)
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        // Initialize an AudioRecorder object
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        currentFile = file
        
        // Start recording
        audioRecorder?.record()
        notifyDelegate()
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
    }
    
    private func notifyDelegate() {
        delegate?.recorderDidChangeState(self)
    }
}
