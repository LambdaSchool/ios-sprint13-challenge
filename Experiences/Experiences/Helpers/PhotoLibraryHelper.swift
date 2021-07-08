//
//  PHPhotoLibraryHelper.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import Photos

class PhotoLibraryHelper {
    static let shared = PhotoLibraryHelper()
    private init() {}
    
    func checkAuthorizationStatus(completion: @escaping (UIAlertController?) -> Void) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            completion(nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    let alert = UIAlertController.informationalAlertController(message: "In order to access the photo library, you must allow this application access to it.")
                    completion(alert)
                    return
                }
                completion(nil)
            }
        case .denied:
            let alert = UIAlertController.informationalAlertController(message: "In order to access the photo library, you must allow this application access to it.")
            completion(alert)
        case .restricted:
            let alert = UIAlertController.informationalAlertController(message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            completion(alert)
        }
    }
}
