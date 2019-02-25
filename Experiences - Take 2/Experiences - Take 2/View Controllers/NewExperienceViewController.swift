
import UIKit
import CoreImage

// In order to be delegate of image picker controller, need to conform
class NewExperienceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PlayerDelegate, RecorderDelegate {
    
    // MARK: - Properties
    
    //var newExperience = Experience(title: nil, audio: nil, video: nil, image: nil, coordinate: nil)
    
    //var experienceController: ExperienceController!
    
    var experienceController = ExperienceController.shared
    
    var location = ExperienceController.shared.location

    //var experiences: ExperienceController
    var experiences = ExperienceController.shared.experiences
    
    var filteredImage: UIImage?
    
    private var originalImage: UIImage? {
        // When image has changed, add our UI
        didSet {
            updateImageView()
        }
    }
    
    private let filter = CIFilter(name: "CIPhotoEffectTonal")
    private let context = CIContext(options: nil)
    
    private let player = Player()
    private let recorder = Recorder()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var saveAudioButton: UIButton!
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.zeroFormattingBehavior = .pad
        f.allowedUnits = [.minute, .second]
        return f
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Experience"
        
        player.delegate = self
        recorder.delegate = self
        
    }
    
    // MARK: - Image Methods
    
    private func updateImageView() {
        // Make sure I have an image
        guard let image = originalImage else { return }
        
        // Put image into my image view and apply filter
        imageView?.image = applyFilter(to: image)
        
        filteredImage = applyFilter(to: image)
        
        // Save image to experience
        //newExperience.image = applyFilter(to: image)
        //        experienceController.experiences[0].image = applyFilter(to: image)
        
        addImageButton.isHidden = true
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Select Source", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            
            // Segue to the camera
            self.performSegue(withIdentifier: "showcamera", sender: nil)
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            
            // Bring up the Photo Library
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("The photo library is unavailable")
                return
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func applyFilter(to image: UIImage) -> UIImage {
        
        let inputImage: CIImage
        
        // If we have a CIImage, use that
        if let ciImage = image.ciImage {
            inputImage = ciImage
        } else if let cgImage = image.cgImage {
            // If we get a cgImage, convert it to a ciImage
            inputImage = CIImage(cgImage: cgImage)
        } else {
            return image
        }
        
        filter?.setValue(inputImage, forKey: "inputImage")
        
        // Retrieve image from filter
        guard let outputImage = filter?.outputImage else {
            return image
        }
        
        // Convert back
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: - UIIMagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get the image the user chose and then dismiss
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Audio Methods
    
    @IBAction func recordAudio(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    @IBAction func tappedPlayButton(_ sender: Any) {
        player.playPause(file: recorder.currentFile)
    }
    
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    
    private func updateViews() {
        let isPlaying = player.isPlaying
        playButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        
        let isRecording = recorder.isRecording
        recordButton.setImage(isRecording ? UIImage(named: "small_mic_filled") : UIImage(named: "small_mic_unfilled"), for: .normal)
        
        let elapsedTime = player.elapsedTime
        elapsedTimeLabel.text = timeFormatter.string(from: player.elapsedTime)
        
        remainingTimeLabel.text = timeFormatter.string(from: player.remainingTime)
        
        timerSlider.minimumValue = 0
        timerSlider.maximumValue = Float(player.totalTime)
        timerSlider.value = Float(player.elapsedTime)
    }
    
    @IBAction func saveAudioButton(_ sender: Any) {
        
        saveAudioButton.setTitle("Saved!", for: [])
        saveAudioButton.tintColor = .gray
        
        guard let audioURL = recorder.currentFile else { return }
        
        experienceController.newExperience = Experience(title: titleTextField.text, audio: audioURL, video: nil, image: applyFilter(to: filteredImage!), coordinate: location!)
        
        //experienceController.newExperience?.title = titleTextField.text
        
        // Save audio to newExperience
        //experienceController.newExperience?.audio = audioURL
//        experiences[0].audio = audioURL
//        experiences[0].title = titleTextField.text
//        experiences[0].image = applyFilter(to: filteredImage!)
        
//        experienceController.experiences[0].audio = audioURL
//        experienceController.experiences[0].title = titleTextField.text
//        experienceController.experiences[0].image = applyFilter(to: filteredImage!)
        

        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        //experienceController.newExperience?.title = titleTextField.text
        //newExperience.title = titleTextField.text
        
    }
    
}
