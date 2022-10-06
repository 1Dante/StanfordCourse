//
//  Document.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 30.06.2022.
//

import UIKit

class ImageGallerieDocument: UIDocument {
  
  var image: [Picture]?
  var thumbnail: UIImage?
  
  override func contents(forType typeName: String) throws -> Any {
    // Encode your document with an instance of NSData or NSFileWrapper
    var data = Data()
    if let image = image {
      for item in image {
        if let itemData = item.data {
          if item.url == image.first?.url {
            data += "[".utf8
          }
          data += itemData
          data += ",".utf8
          if item.url == image.last?.url {
            data += "]".utf8
          }
        }
      }
      return data
    }
    return Data()
  }
  
  override func load(fromContents contents: Any, ofType typeName: String?) throws {
    // Load your document from contents
    if let data = contents as? Data {
      image = Picture.convertFromDataToPicture(data: data)
    }
  }
  
  override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
    var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
    if let thumbnail = self.thumbnail {
      attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
    }
    return attributes
  }
}
