
import UIKit
import CoreImage

// In order to be delegate of image picker controller, need to conform
class NewExperienceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var originalImage: UIImage? {
        // When image has changed, add our UI
        didSet {
            updateImageView()
        }
    }
    
    private let filter = CIFilter(name: "CIPhotoEffectTonal")
    private let context = CIContext(options: nil)
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func updateImageView() {
        // Make sure I have an image
        guard let image = originalImage else { return }
        
        // Put image into my image view and apply filter
        imageView?.image = applyFilter(to: image)
        
        addImageButton.setTitle("", for: [])
    }

    @IBAction func chooseImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is unavailable")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
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
    
    
    
}
