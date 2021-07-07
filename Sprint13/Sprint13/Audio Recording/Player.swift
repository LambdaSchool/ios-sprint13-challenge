
import Foundation
import AVFoundation

// Purpose of this file: This will be thething that owns and interacts with all of the audio playback in my app. That way I don't have to have audio playback code directly in my view controller. View controller doing both playback and recording AND view updates, will make it get super big, so that's why wer are creating new files so the VC can only focus on controlling the views

// Create a delegate for the player so that we know when something happens - when something changes, we tell the delegate
protocol PlayerDelegate: AnyObject {
    
    // indication to say that the player has changed somehow
    func playerDidChangeState(_ playe: Player)
}

// We will be the delegate of the play recorder, so we MUST be an NSObject
class Player: NSObject, AVAudioPlayerDelegate {
    
    // Need an audio player
    // Don't want anyone else to know about it
    // Optional so that we can create it when we are ready
    private var audioPlayer: AVAudioPlayer?
    
    // Add a timer so it can continuously update the label
    private var timer: Timer?
    
    weak var delegate: PlayerDelegate?
    
    // Need to know whether thplayer is currently playing something or not so that we can update our button title to match
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    // I want to know how much of the song has played
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
    func playPause(song: URL? = nil) {
        if isPlaying {
            pause()
        } else {
            play(song: song)
        }
    }
    
    // Start playing
    func play(song: URL? = nil) {
        
        // First figure out which file I should be playing - I prefer it to be a song if I have one
       // let file = song ?? nil //Bundle.main.url(forResource: "music", withExtension: "mp3")!
        
        // URL it's currently playing - if the file that is currently playing is not the file I want to be playing, then recreate the audio player to play the thing I want to be playing
       // if audioPlayer == nil || audioPlayer?.url != file {
            // If audioPlayer is nil, make an audio player
            //let songURL = Bundle.main.url(forResource: "smallthoughts", withExtension: "m4a")!
            //audioPlayer = try! AVAudioPlayer(contentsOf: songURL)
        if let file = song {
            audioPlayer = try! AVAudioPlayer(contentsOf: file)
            
            audioPlayer?.delegate = self
        }
        
        audioPlayer?.play()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [weak self] _ in
            // Everytime the timer fires, notify the delegate
            self?.notifyDelegate()
            })
    
            notifyDelegate()
    }
    
    // Stop playing
    func pause() {
        audioPlayer?.pause()
        timer?.invalidate()
        timer = nil
        notifyDelegate()
    }
    
    private func notifyDelegate() {
        delegate?.playerDidChangeState(self)
    }
    
    // I also want to know when the song is finished - which I can know through the AVAudioPlayerDelegate. It has a method called:
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        notifyDelegate()
    }
}
