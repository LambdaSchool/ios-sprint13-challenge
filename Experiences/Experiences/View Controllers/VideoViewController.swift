//
//  VideoViewController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var playerView: PlaybackView!
    
    var post: Post?
    var postController: PostController?
    var player: AVPlayer?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Title", message: nil, preferredStyle: .alert)
                
                var commentTextField: UITextField?
                
                alert.addTextField { (textField) in
                    textField.placeholder = "Type your title"
                    commentTextField = textField
                }
                
                let addTitleAction = UIAlertAction(title: "Save", style: .default) { (_) in
                    
                    guard let commentText = commentTextField?.text else { return }
                    
        //            self.postController.addComment(with: .text(commentText), to: self.post!)
                    
                    DispatchQueue.main.async {
        //                self.tableView.reloadData()
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(addTitleAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion: nil)
    }
}
