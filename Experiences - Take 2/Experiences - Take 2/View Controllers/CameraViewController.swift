
import UIKit

class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Camera"
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {}
        
        func configureCaptureDevices() throws {}
        
        func configureDeviceInputs() throws {}
        
        func configurePhotoOutput() throws {}
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    
}
