import UIKit
import AVFoundation

class VideoPreviewView: UIView {
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // Get access to the layer
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        
        // force cast our layer to be an AVCaptureVideoPreviewLayer
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    // Convenience property for accessing/setting the AVCapture session
    var session: AVCaptureSession? {
        get { return videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
    }
}
