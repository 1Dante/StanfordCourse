//
//  Extentions.swift
//  Project_3_Graphical_Set
//
//  Created by Viktor on 25.07.2022.
//

import UIKit

extension UIColor {
  static var attributedColor: UIColor {
    return [UIColor.red, UIColor.green, UIColor.purple].randomElement()!
  }
}

extension Int {
  static var attributedInt: Int {
    return [1,2,3].randomElement() ?? 1
  }
}



