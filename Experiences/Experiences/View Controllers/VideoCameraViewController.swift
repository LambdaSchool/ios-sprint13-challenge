
import UIKit
import AVFoundation
import Photos

class VideoCameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    private let captureSession = AVCaptureSession()
    private let fileOutput = AVCaptureMovieFileOutput()
    var outputURL: URL!
    
    @IBOutlet weak var cameraView: VideoPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.setImage(UIImage(named: "record"), for: .normal)
        recordButton.layer.cornerRadius = 25
        
        // SESSION INPUTS
        
        // Set up the capture session
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input from the camera")
        }
        
        // Make sure my method can handle this kind of input
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this kind of input")
        }
        captureSession.addInput(cameraInput)
        
        // SESSION OUTPUTS
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to file")
        }
        captureSession.addOutput(fileOutput)
        
        // Tell capture session what resolution of video
        captureSession.sessionPreset = .hd1920x1080
        
        // Commit
        captureSession.commitConfiguration()
        
        // Show the session in the UI
        cameraView.session = captureSession
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Request permission to use the camera

        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    fatalError("Need to ask the user for authorization")
                }
                DispatchQueue.main.async {
                    self.captureSession.startRunning()
                }
            }
        case .restricted:
            fatalError("Parental controls on the device are preventing access to the camera")
        case .denied:
            fatalError("User has denied access to the camera")
        case .authorized:
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    @IBAction func toggleRecord(_ sender: Any) {
        
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            recordButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            recordButton.setImage(UIImage(named: "record"), for: .normal)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            
            // Save to firebase using url
            
            
        }
    }
    
    // MARK: - Private Methods
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("We are on a device that doesn't have a camera")
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        
        let name = f.string(from: Date())
        return documents.appendingPathComponent(name).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        let isRecording = fileOutput.isRecording
        //recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
    }
    
}
