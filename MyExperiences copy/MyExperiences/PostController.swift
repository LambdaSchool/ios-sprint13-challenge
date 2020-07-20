//
//  PostController.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MapKit
import CoreLocation

class PostController {
    
    func createPost(with title: String, ofType mediaType: MediaType, mediaData: Data, ratio: CGFloat? = nil, geotag: CLLocationCoordinate2D? = nil, completion: @escaping (Bool) -> Void = { _ in }) {
        
        guard let currentUser = Auth.auth().currentUser,
            let author = Author(user: currentUser) else { return }
        let ref = storageRef.child(mediaType.rawValue)
        
        store(mediaData: mediaData, storage: ref) { (mediaURL) in
            
            guard let mediaURL = mediaURL else { completion(false); return }
            
            switch mediaType {
            case .image:
                let imagePost = Post(title: title, mediaURL: mediaURL, ratio: ratio, author: author, mediaType: mediaType)
                imagePost.geotag = geotag
                
                self.postsRef.childByAutoId().setValue(imagePost.dictionaryRepresentation) { (error, ref) in
                    if let error = error {
                        NSLog("Error posting image post: \(error)")
                        completion(false)
                    }
                    completion(true)
                }
            case .video:
                let videoPost = Post(title: title, mediaURL: mediaURL, ratio: ratio, author: author, mediaType: mediaType)
                videoPost.geotag = geotag
                
                self.postsRef.childByAutoId().setValue(videoPost.dictionaryRepresentation) { (error, ref) in
                    if let error = error {
                        NSLog("Error posting image post: \(error)")
                        completion(false)
                    }
                    completion(true)
                }
            }
        }
    }
    
    func addComment(with text: String, to post: inout Post) {
        
        guard let currentUser = Auth.auth().currentUser,
            let author = Author(user: currentUser) else { return }
        
        let comment = Comment(text: text, author: author)
        post.comments.append(comment)
        
        savePostToFirebase(post)
    }
    
    func addAudioComment(with comment: Comment, to post: inout Post) {
        post.comments.append(comment)
        savePostToFirebase(post)
        
        
        
    }
    
    func createAudioComment(with mediaData: Data, completion: @escaping (Comment?) -> Void = {_ in}) {
        
        guard let currentUser = Auth.auth().currentUser,
            let author = Author(user: currentUser) else { return }
        
        let ref = storageRef.child("audio")
        store(mediaData: mediaData, storage: ref) { (mediaURL) in
            
            guard let mediaURL = mediaURL else { completion(nil); return }
            
            let audioComment = Comment(text: nil, author: author, audioURL: mediaURL)
            completion(audioComment)
            
        }
    }
    
    func observePosts(completion: @escaping (Error?) -> Void) {
        
        postsRef.observe(.value, with: { (snapshot) in
            
            guard let postDictionaries = snapshot.value as? [String: [String: Any]] else { return }
            
            var posts: [Post] = []
            
            
            // Here is where the posts pulled down from the server are being sorted.
            for (key, value) in postDictionaries {
                
                guard let post = Post(dictionary: value, id: key) else { continue }
                
                posts.append(post)
            }
            // Then they are sorted by timestamp with the newest timestamps being the first on the list being displayed first.
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
            
            completion(nil)
            
        }) { (error) in
            NSLog("Error fetching posts: \(error)")
        }
    }
    
    func savePostToFirebase(_ post: Post, completion: (Error?) -> Void = { _ in }) {
        
        guard let postID = post.id else { return }
        
        let ref = postsRef.child(postID)
        
        ref.setValue(post.dictionaryRepresentation)
    }
    
    
    //Here you can also change mediaType to Storage refrence. I guess that is what they are reffering to with this instruction
    
    /*
     You can very easily change the store method to instead take in data and a StorageReference to accomodate for storing both Post media data and now the audio data as well.
     */
    private func store(mediaData: Data, storage: StorageReference, completion: @escaping (URL?) -> Void) {
        
        let mediaID = UUID().uuidString
        
        let mediaRef = storage.child(mediaID)
        
        let uploadTask = mediaRef.putData(mediaData, metadata: nil) { (metadata, error) in
            if let error = error {
                NSLog("Error storing media data: \(error)")
                completion(nil)
                return
            }
            
            //? ( DO NOT understand this code snippet below.)
            if metadata == nil {
                NSLog("No metadata returned from upload task.")
                completion(nil)
                return
            }
            
            mediaRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    NSLog("Error getting download url of media: \(error)")
                }
                
                guard let url = url else {
                    NSLog("Download url is nil. Unable to create a Media object")
                    
                    completion(nil)
                    return
                }
                completion(url)
            })
        }
        
        uploadTask.resume()
    }
    
    var posts: [Post] = []
    let currentUser = Auth.auth().currentUser
    let postsRef = Database.database().reference().child("posts")
    let storageRef = Storage.storage().reference()
    
    
}
