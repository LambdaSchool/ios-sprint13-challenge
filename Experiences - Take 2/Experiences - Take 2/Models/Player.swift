import Foundation
import AVFoundation

protocol PlayerDelegate: AnyObject {
    func playerDidChangeState(_ player: Player)
}

class Player: NSObject, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    weak var delegate: PlayerDelegate?
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var elapsedTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    var totalTime: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var remainingTime: TimeInterval {
        return totalTime - elapsedTime
    }
    
    // Convenience for pause and play
    func playPause(file: URL? = nil) {
        if isPlaying {
            pause()
        } else {
            play(file: file)
        }
    }
    
    func play(file: URL? = nil) {
        
        guard let currentFile = file else { return }
        
        // Make an audio player
        audioPlayer = try! AVAudioPlayer(contentsOf: currentFile)
        
        audioPlayer?.delegate = self
        
        audioPlayer?.play()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [weak self] _ in
            // Everytime the timer fires, notify the delegate
            self?.notifyDelegate()
        })
        
        notifyDelegate()
    }
    
    func pause() {
        audioPlayer?.pause()
        timer?.invalidate()
        timer = nil
        notifyDelegate()
    }
    
    private func notifyDelegate() {
        delegate?.playerDidChangeState(self)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        notifyDelegate()
    }
    
}
