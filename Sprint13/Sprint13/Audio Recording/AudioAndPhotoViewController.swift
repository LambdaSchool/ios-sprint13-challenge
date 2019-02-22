
import UIKit

protocol AudioPostDelegate {
    func recordedFile(audio: URL)
}

class AudioAndPhotoViewController: UIViewController, PlayerDelegate, RecorderDelegate {
   
    
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func choosePhoto(_ sender: Any) {
        
        
    }
    
   
    @IBAction func next(_ sender: Any) {
        
        guard let audioURL = recorder.currentFile else { return }
       
        let data = try? Data(contentsOf: audioURL)
    
       
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
     let player = Player()
     let recorder = Recorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.delegate = self
        recorder.delegate = self
    }

    @IBAction func tappedPlayButton(_ sender: Any) {
        // returns either the song if there is nothing recorded, or the most recent URL I have recorded
        player.playPause(song: recorder.currentFile)
    }
    
    @IBAction func tappedRecordButton(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    // I want a single method to use to update everything at once
    private func updateViews() {
        let isPlaying = player.isPlaying
        playButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        
        let isRecording = recorder.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
        
    }
    

}

