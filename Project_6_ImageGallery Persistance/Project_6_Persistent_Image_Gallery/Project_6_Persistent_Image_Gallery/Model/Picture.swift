//
//  Image.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 01.07.2022.
//

import Foundation
import UIKit

struct Picture: Codable {
  var url: URL
  var aspectRatio: Double
  var data: Data? {
    return try? JSONEncoder().encode(self)
  }
  
  init(url: URL, aspectRatio: Double) {
    self.url = url
    self.aspectRatio = aspectRatio
  }
  
  static func convertFromDataToPicture(data: Data) -> [Picture]? {
    
    if let newValue = try? JSONDecoder().decode([Picture].self, from: data) {
      return newValue
    } else {
      return nil
    }
  }
}

