//
//  PhotoCollectionViewCell.swift
//  memories
//
//  Created by Clayton Watkins on 9/10/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
protocol cellIndexPathDelegate: AnyObject {
    func locationButtonTapped(cell: PhotoCollectionViewCell)
}
class PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Properties
    var post: Post?{
        didSet{
            updateViews()
        }
    }
    var delegate: cellIndexPathDelegate?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
         super.layoutSubviews()
     }
     
     override func prepareForReuse() {
         super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
        authorLabel.text = ""
     }
    
    // MARK: - Private
   private func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        authorLabel.text = post.author
        imageView.image = post.image
    }
    
    // MARK: - IBAction
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(cell: self)
    }
}
