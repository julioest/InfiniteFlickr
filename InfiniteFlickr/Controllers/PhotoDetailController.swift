//
//  PhotoDetailController.swift
//  InfiniteFlickr
//
//  Created by Julio Estrada on 2/20/18.
//  Copyright © 2018 Julio Estrada. All rights reserved.
//

import UIKit

class PhotoDetailController: UIViewController {

    // MARK: - Properties
    var imageView: UIImageView!
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupImageView()
        store.fetchImage(for: photo) { (result) in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }

    // MARK: - Setup Views
    fileprivate func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: view.bounds.size.width, height: view.bounds.size.height))
    }
}
