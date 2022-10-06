//
//  ImageCache.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 05.07.2022.
//

import Foundation
import UIKit

class ImageCacheRepository {
  
  private lazy var cache: URLCache = {
    let allowedDiskSpace = 100 * 1024 * 1024
    let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
    return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSpace, directory: diskCacheURL)
  }()
  
  
  typealias DownloadCompletion = (Result<Data,Error>) -> ()
  
  func getImage(imageURL: URL, downloadedImageCompletion: @escaping ((Bool) -> Void)) -> UIImage {
    var image = UIImage()
    downloadContent(imageURL: imageURL, completion: { result in
      switch result {
      case .success(let data):
        image = UIImage(data: data) ?? UIImage(systemName: "xmark.icloud")!
        downloadedImageCompletion(true)
      case .failure(let error):
        image = UIImage(systemName: "xmark.icloud")!
        downloadedImageCompletion(true)
      }
    })
    return image
  }
  
  private func createAndRetrieveURLSession() -> URLSession {
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
    sessionConfiguration.urlCache = cache
    return URLSession(configuration: sessionConfiguration)
  }
  
  private func downloadContent(imageURL: URL, completion: @escaping DownloadCompletion) {
    let request = URLRequest(url: imageURL)
    if let cachedData = self.cache.cachedResponse(for: request) {
      // print("Cached data in bytes:", cachedData.data)
      completion(.success(cachedData.data))
    } else {
      createAndRetrieveURLSession().dataTask(with: request) { data, response, error in
        if let error = error {
          completion(.failure(error))
        } else {
          let cachedDataResponse = CachedURLResponse(response: response!, data: data!)
          self.cache.storeCachedResponse(cachedDataResponse, for: request)
          completion(.success(data!))
        }
      }.resume()
    }
  }
}
