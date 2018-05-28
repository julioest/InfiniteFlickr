//
//  PhotoDataSource.swift
//  InfiniteFlickr
//
//  Created by Julio Estrada on 2/20/18.
//  Copyright © 2018 Julio Estrada. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {

    var photos = [Photo]()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.defaultIdentifier, for: indexPath) as! PhotoCell
        return cell
    }
}
