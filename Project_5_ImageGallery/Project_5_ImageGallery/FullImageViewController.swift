//
//  FullImageViewController.swift
//  Project_5_ImageGallery
//
//  Created by Viktor on 24.06.2022.
//

import UIKit

class FullImageViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  var imageURL = URL(string: "")
 
  override func viewDidLoad() {
        super.viewDidLoad()
    
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 5.0
    if let imageURL = imageURL {
      DispatchQueue.main.async {
        if let data = try? Data(contentsOf: imageURL) {
          self.imageView.image = UIImage(data: data)
        } else {
          self.imageView.image = UIImage(systemName: "xmark.icloud")
        }
      }
    }
    imageView.contentMode = .scaleAspectFit
    scrollView.delegate = self
    
  }

}

extension FullImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
