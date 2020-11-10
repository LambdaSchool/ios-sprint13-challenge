//
//  LoginViewController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import AVFoundation
import AVKit

class LoginViewController: UIViewController {
    
    @IBOutlet var backgroundVideoView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Login", ofType: "mov")!))
    var newPlayer = AVPlayerLayer(player: nil)
    let postExperiencesController = PostExperiencesController.shared
    
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
            performSegue(withIdentifier: "ExperienceCollectionSegue", sender: nil)
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        UserDefaults.standard.set(username, forKey: "username")
        segueIfUsernameExists()
    }

}
