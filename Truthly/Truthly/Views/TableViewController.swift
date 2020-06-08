//
//  TableViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: Properties -
    
    var postController: PostController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
           tableView.reloadData()
       }

       
    @IBAction func addPostTapped(_ sender: Any) {
        addPost()
    }
    
        private func addPost() {
            let alert = UIAlertController(title: "New Post", message: nil, preferredStyle: .actionSheet)

            let imagePostAction = UIAlertAction(title: "Image", style: .default) { (_) in
                self.performSegue(withIdentifier: "ModalImageSegue", sender: nil)
            }

            let audioPostAction = UIAlertAction(title: "Audio", style: .default) { (_) in
                self.performSegue(withIdentifier: "ModalAudioSegue", sender: nil)
            }

            let videoPostAction = UIAlertAction(title: "Video", style: .default) { (_) in
                self.performSegue(withIdentifier: "ModalVideoSegue", sender: nil)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(imagePostAction)
            alert.addAction(audioPostAction)
            alert.addAction(videoPostAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        }

        // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return postController?.posts.count ?? 0
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = postController?.posts[indexPath.row].postTitle
            cell.detailTextLabel?.text = postController?.posts[indexPath.row].mediaType.rawValue

            return cell
        }

        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier {
            case "ModalImageSegue":
                if let destinationVC = segue.destination as? ImageViewController {
                    destinationVC.postController = self.postController
                    destinationVC.delegate = self
                }
            case "ModalAudioSegue":
                if let destinationVC = segue.destination as? AudioViewController {
                    destinationVC.postController = self.postController
                    destinationVC.delegate = self
                }
            case "ModalVideoSegue":
                if let destinationVC = segue.destination as? VideoViewController {
                    destinationVC.postController = self.postController
                    destinationVC.delegate = self
                }
            default:
                return
            }
        }
    }



    extension TableViewController: ImageDelegate, AudioDelegate, VideoDelegate {
        func imageButtonTapped() {
            tableView.reloadData()
        }
        func videoButtonTapped() {
            tableView.reloadData()
        }
        func audioButtonTapped() {
            tableView.reloadData()
        }



    }
