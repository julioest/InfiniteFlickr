//
//  PhotoCell.swift
//  InfiniteFlickr
//
//  Created by Julio Estrada on 2/19/18.
//  Copyright © 2018 Julio Estrada. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let defaultIdentifier: String = "PhotoCell"
    private var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        var image = #imageLiteral(resourceName: "heart")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var photoImageView: UIImageView!
    private var spinner: UIActivityIndicatorView!

    // MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }

    // MARK: - Setup Views
    func setupAllViews() {
        backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        setupImageView()
        setupSpinner()
        setupFavoriteButton()
    }

    func setupImageView() {
        photoImageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        photoImageView.backgroundColor = .white
        photoImageView.contentMode = .scaleAspectFill
        addSubview(photoImageView)
        photoImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    func setupSpinner() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        addSubview(spinner)
        spinner.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    func setupFavoriteButton() {
        addSubview(favoriteButton)
        favoriteButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: .init(width: 60, height: 60))
        favoriteButton.addTarget(self, action: #selector(didTapFavorite(_:)), for: .touchUpInside)
    }
    
    @objc func didTapFavorite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.setImage(#imageLiteral(resourceName: "heart_active"), for: .selected)
    }

    // MARK: - Functions
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
            photoImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            photoImageView.image = nil
        }
    }
}


