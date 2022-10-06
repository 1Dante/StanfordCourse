//
//  File.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 01.07.2022.
//

import UIKit

class ImageViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  var imageURL = URL(string: "")
  var imageCacheRepo = ImageCacheRepository()
 
  override func viewDidLoad() {
        super.viewDidLoad()
    
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 5.0
    if let imageURL = imageURL {
      self.imageView.image = imageCacheRepo.getImage(imageURL: imageURL.imageURL, downloadedImageCompletion: { _ in })
    }
    imageView.contentMode = .scaleAspectFit
    scrollView.delegate = self
  }

}

extension ImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}

