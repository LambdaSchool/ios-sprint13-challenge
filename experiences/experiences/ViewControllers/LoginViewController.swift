//
//  LoginViewController.swift
//  experiences
//
//  Created by Clayton Watkins on 9/11/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var backgroundVideoView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    // MARK: - Properties
    let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "login", ofType: "mov")!))
    var newPlayer = AVPlayerLayer(player: nil)
    let postController = PostController.shared
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segueIfUsernameExists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        view.addSubview(loginView)
    }
    
    override func viewDidLayoutSubviews() {
         newPlayer.frame = self.backgroundVideoView.bounds
     }
    // MARK: - Private Methods
    
    private func setupView() {
        newPlayer = AVPlayerLayer(player: player)
        newPlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.backgroundVideoView.layer.addSublayer(newPlayer)
        
        
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidPlayToEnd(_: )), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
    }
    
    @objc private func videoDidPlayToEnd(_ notification: Notification) {
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero, completionHandler: nil)
    }
    
    private func segueIfUsernameExists() {
          if UserDefaults.standard.string(forKey: "username") != nil {
              performSegue(withIdentifier: "MemoriesCollectionSegue", sender: nil)
          }
      }
    
    // MARK: - IBAction
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        UserDefaults.standard.set(username, forKey: "username")
        segueIfUsernameExists()
    }
}
