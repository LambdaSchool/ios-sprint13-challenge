//
//  CreateExperienceViewController.swift
//  Experience
//
//  Created by Simon Elhoej Steinmejer on 19/10/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class TitleAndPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var pickedImage: UIImage?
    
    var titleTextField: UITextField =
    {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    let addPhotoButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        navigationItem.title = "Select title and photo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(addVideoRecording))
    }
    
    @objc private func addPhoto()
    {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[.editedImage] as? UIImage
        {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            pickedImage = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            pickedImage = originalImage
        }
        addPhotoButton.layer.borderWidth = 1.5
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addVideoRecording()
    {
        guard let image = pickedImage, let title = titleTextField.text else { return }
        DataContainer.shared.title = title
        DataContainer.shared.photo = image
        
        let videoRecordingViewController = VideoRecordingViewController()
        navigationController?.pushViewController(videoRecordingViewController, animated: true)
    }
    
    private func setupViews()
    {
        view.addSubview(titleTextField)
        view.addSubview(addPhotoButton)
        
        titleTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 40)
        
        addPhotoButton.anchor(top: titleTextField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 80, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 300, height: 300)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
