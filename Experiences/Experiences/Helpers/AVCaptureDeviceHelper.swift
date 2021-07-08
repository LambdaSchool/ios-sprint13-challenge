//
//  AVCaptureDeviceHelper.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import AVFoundation

class AVCaptureDeviceHelper {
    
    static let shared = AVCaptureDeviceHelper()
    private init () {}
    
    func checkAuthorizationStatus(completion: @escaping (UIAlertController?) -> Void = { _ in }) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .authorized:
            completion(nil)
        case .denied:
            let alert = UIAlertController.informationalAlertController(message: "In order to record video, you must allow this application to access the camera.")
            completion(alert)
        case .restricted:
            let alert = UIAlertController.informationalAlertController(message: "Unable to access the camera. Your device's restrictions do not allow access.")
            completion(alert)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    let alert = UIAlertController.informationalAlertController(message: "In order to record video, you must allow this application to access the camera.")
                    completion(alert)
                    fatalError("Give me access!")
                }
            }
        }
    }
    
}
