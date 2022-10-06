//
//  ExtentionViewController.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 03.07.2022.
//

import UIKit

extension UIViewController {
  var contents: UIViewController {
    if let navCon = self as? UINavigationController {
      return navCon.visibleViewController ?? navCon
    } else {
      return self
    }
  }
}
