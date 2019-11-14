//
//  ContainerViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var media: Media?
    var mediaType: MediaType?{
        didSet{
            
        }
    }
    var delegate: ExperienceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleMedia() {
        guard let type = mediaType else { return }
        switch type {
        case .audio:
            add(asChildViewController: audioViewController)
        case .image:
            
            break
        case .video:
            break
        }
    }
    
    private lazy var audioViewController: AudioViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AudioPlayerViewController") as! AudioViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    
    private lazy var videoViewController: VideoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    private lazy var imageViewController: ImageViewController = {
           // Load Storyboard
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

           // Instantiate View Controller
           var viewController = storyboard.instantiateViewController(withIdentifier: "VideoRecorderViewController") as! ImageViewController

           // Add View Controller as Child View Controller
           self.add(asChildViewController: viewController)

           return viewController
       }()

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }

    private func updateView() {

        //add(asChildViewController: registerViewController)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
