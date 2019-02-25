//
//  AppDelegate.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Device Permissions Authorization
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
            
        case .notDetermined:
            // we have not asked user yet
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    fatalError("Please don't do this in an actual app")
                }
                return
            }
            
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted == false {
                    fatalError("Please don't do this in an actual app")
                }
                return
            }
            
        case .restricted:
            // parental controls prevent access to cameras
            fatalError("Please have better scenario handling than this")
            
        case .denied:
            // asked for permission and said NO
            fatalError("Please have better scenario handling than this")
        case .authorized:
            // asked for permission and said YES
            break
        }

        // MARK: - Test Annotations on Startup
        let testExperience1 = Experience(experienceName: "test experience", audioMemory: nil, videoMemoryURL: nil, experienceImage: nil, location: CLLocationCoordinate2D(latitude: 41.95684814453125, longitude: -85.70046556077921))
        let testExperience2 = Experience(experienceName: "test experience 2", audioMemory: nil, videoMemoryURL: nil, experienceImage: nil, location: CLLocationCoordinate2D(latitude: 42.95684814453125, longitude: -88.70046556077921))
        Experiences.experiences.append(testExperience1)
        Experiences.experiences.append(testExperience2)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

