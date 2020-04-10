//
//  UserExperienceViewController.swift
//  UX
//
//  Created by Nick Nguyen on 4/10/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation

class UserExperienceViewController: UIViewController, UIGestureRecognizerDelegate
{

    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        dismiss(animated: true, completion: nil)
    }
    
    
    private let titleTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Title..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .bezel
        textField.becomeFirstResponder()
        return textField
    }()
    
    lazy private var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "camera"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
        
    }()
    
    @objc func cameraPicked(sender: UITapGestureRecognizer) {
        print("Hello")
        showImagePickerControllerActionSheet()
    }
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleTextField)
        view.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cameraPicked))
        tap.delegate = self
        imageView.addGestureRecognizer(tap)
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        view.backgroundColor = .white
        setUpNavigationBar()
        contrainstViews()
    }
    
    
    private func contrainstViews() {
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,constant: 32),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        
        ])
        
        
    }
    
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "New Experience"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
    }
    

}
extension UserExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet() {
           let ac = UIAlertController(title: "Choose your book's cover", message: nil, preferredStyle: .actionSheet)
           let firstAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
               self.showImagePickerController(sourceType: .photoLibrary)
           }
           let secondAction = UIAlertAction(title: "Take new photo", style: .default) { (action) in
               self.showImagePickerController(sourceType: .camera)
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
           ac.addAction(firstAction)
           ac.addAction(secondAction)
           ac.addAction(cancelAction)
           present(ac, animated: true, completion: nil)
       }
       
       
       
       func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.allowsEditing = true
           imagePickerController.sourceType = sourceType
           present(imagePickerController, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
               imageView.image = editedImage
          } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           imageView.image = originalImage
           }
           dismiss(animated: true, completion: nil)
       }
}
