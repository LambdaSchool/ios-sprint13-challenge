//
//  AppDelegate.swift
//  ExperienceTracker
//
//  Created by Jonathan T. Miles on 10/19/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { (granted) in
            if !granted {
                NSLog("Please give ExperienceTracker permission to access the microphone in Settings")
                return
            }
            
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: [])
                try session.setActive(true, options: [])
            } catch {
                NSLog("Error setting up AVSession: \(error)")
            }
        }
        
        
        return true
    }
    
}

