//
//  AudioRecordingViewController.swift
//  Experience
//
//  Created by Simon Elhoej Steinmejer on 19/10/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class VideoRecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate
{
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    private var capturedUrl: URL?
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?)
    {
        self.capturedUrl = outputFileURL
        print(outputFileURL)
    }
    
    let previewView: CameraPreview =
    {
        let view = CameraPreview()
        
        return view
    }()
    
    let recordButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Record"), for: .normal)
        button.addTarget(self, action: #selector(handleRecording), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleRecording()
    {
        if recordOutput.isRecording
        {
            recordOutput.stopRecording()
        }
        else
        {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
        updateViews()
    }
    
    private func updateViews()
    {
        guard isViewLoaded else { return }
        
        let recordButtonImageName = recordOutput.isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImageName), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.captureSession.startRunning()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if !granted { fatalError("VideoFilters needs camera access") }
                self.captureSession.startRunning()
            }
        case .denied:
            fallthrough
        case .restricted:
            fatalError("VideoFilters needs camera access")
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCapture()
        navigationItem.title = "Record Video"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(handleUpload))
        view.addSubview(previewView)
        previewView.addSubview(recordButton)
        
        previewView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        recordButton.anchor(top: nil, left: nil, bottom: previewView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -50, width: 70, height: 70)
        recordButton.centerXAnchor.constraint(equalTo: previewView.centerXAnchor).isActive = true
    }
    
    @objc private func handleUpload()
    {
        guard let url = capturedUrl else { return }
        let id = UUID().uuidString
        let dispatchGroup = DispatchGroup()
        var photoUrl: String?
        var videoUrl: String?
        
        dispatchGroup.enter()
        uploadVideo(url: url, id: id) { (url) in
            videoUrl = url
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        uploadPhoto(id: id) { (url) in
            photoUrl = url
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let videoUrl = videoUrl, let photoUrl = photoUrl else { return }
            self.uploadToDatabase(videoUrl: videoUrl, photoUrl: photoUrl, id: id)
        }
    }
    
    private func uploadVideo(url: URL, id: String, completion: @escaping (String) -> ())
    {
        let uploadRef = Storage.storage().reference().child("experiences").child(id).putFile(from: url)
        
        uploadRef.observe(.success) { (snapshot) in
            
            snapshot.metadata?.storageReference?.downloadURL(completion: { (url, error) in
                
                completion((url?.absoluteString)!)
            })
        }
    }
    
    
    private func uploadPhoto(id: String, completion: @escaping (String) -> ())
    {
        let data = DataContainer.shared.photo!.jpegData(compressionQuality: 0.3)!
        let uploadRef = Storage.storage().reference().child("experiences").child(id).putData(data)
        
        uploadRef.observe(.success) { (snapshot) in
            
            snapshot.metadata?.storageReference?.downloadURL(completion: { (url, error) in
                
                completion((url?.absoluteString)!)
            })
        }
    }
    
    private func uploadToDatabase(videoUrl: String, photoUrl: String, id: String)
    {
        let values = ["videoUrlString": videoUrl, "imageUrlString": photoUrl, "title": DataContainer.shared.title!]
        
        Database.database().reference().child("experiences").child(id).updateChildValues(values)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        
        previewView.videoPreviewLayer.session = captureSession
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func bestCamera() -> AVCaptureDevice
    {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        {
            return device
        }
        else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        {
            return device
        }
        else
        {
            fatalError("Missing expected back camera device")
        }
    }
}
