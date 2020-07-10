//
//  AppDelegate.swift
//  Experiences
//
//  Created by Enayatullah Naseri on 3/21/20.
//  Copyright © 2020 Enayatullah Naseri. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        requestPermissions()
        return true
    }
    // MARK: - Permissions 
    private func requestPermissions() {
        let permission = AVAudioSession.sharedInstance()
        permission.requestRecordPermission { (granted) in
            guard granted == true else {
                print("Error: we need microphone permission, to record audio")
                return
            }
            
            do {
                try permission.setCategory(.playAndRecord, mode: .default, options: [])
                try permission.overrideOutputAudioPort(.speaker)
                try permission.setActive(true, options: [])
            } catch {
                print("Error setting up audio session: \(error)")
            }
        }
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user they need to enable privacy for Video/Camera/Microphone")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

