//
//  PhotoStore.swift
//  InfiniteFlickr
//
//  Created by Julio Estrada on 2/19/18.
//  Copyright © 2018 Julio Estrada. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    // MARK: - Properties
    let imageStore = ImageStore()
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "InfiniteFlickr")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("Error setting up Core Data: \(error)")
            }
        }
        return container
    }()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    // MARK: - Functions
    func searchFlickr(with searchText: String, completion: @escaping (PhotosResult) -> ()) {
        let url = FlickrAPI.searchURL(searchText)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            var result = self.processPhotosRequest(data: data, error: error)

            if case .success = result {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch let error {
                    result = .failure(error)
                }
            }

            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }

    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
    }

    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> ()) {
        
        guard let photoKey = photo.photoID,
        let photoURL = photo.remoteURL else {
            return 
        }

        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }

        let request = URLRequest(url: photoURL as! URL)
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }

    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        return .success(image)
    }

    func fetchAllPhotos(completion: @escaping (PhotosResult) -> ()) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        // TODO: - Fix this, figure out how you want to sort photos

//        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
//        fetchRequest.sortDescriptors = [sortByDateTaken]

        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

