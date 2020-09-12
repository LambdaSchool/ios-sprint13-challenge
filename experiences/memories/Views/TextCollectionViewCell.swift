//
//  TextCollectionViewCell.swift
//  memories
//
//  Created by Clayton Watkins on 9/10/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

protocol cellIndexPathDelegate3: AnyObject {
    func locationButtonTapped(cell: TextCollectionViewCell)
}

class TextCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Properties
    var post: Post?{
        didSet{
            updateViews()
        }
    }
    var delegate: cellIndexPathDelegate3?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = ""
        titleLabel.text = ""
        authorLabel.text = ""
    }
    
    // MARK: - Private
    private func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        authorLabel.text = post.author
        textView.text = post.entry
    }
    
    // MARK: - IBAction
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(cell: self)
    }
}
