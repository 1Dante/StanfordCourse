//
//  DocumentBrowserViewController.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 30.06.2022.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
  
  var template: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    
    allowsDocumentCreation = false
    allowsPickingMultipleItems = false
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      template = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Unitled.json")
    }
    
    if template != nil {
      allowsDocumentCreation = FileManager.default.createFile(atPath: template! .path, contents: Data())
    }
    
    // Update the style of the UIDocumentBrowserViewController
    // browserUserInterfaceStyle = .dark
    // view.tintColor = .white
    
    // Specify the allowed content types of your application via the Info.plist.
    
    // Do any additional setup after loading the view.
  }
  
  // MARK: UIDocumentBrowserViewControllerDelegate
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
    
    importHandler(template , .copy )
    // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
    // Make sure the importHandler is always called, even if the user cancels the creation request.
    //      if newDocumentURL != nil {
    //            importHandler(newDocumentURL, .move)
    //        } else {
    //            importHandler(nil, .none)
    //        }
  }
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
    guard let sourceURL = documentURLs.first else { return }
    
    // Present the Document View Controller for the first document that was picked.
    // If you support picking multiple items, make sure you handle them all.
    presentDocument(at: sourceURL)
  }
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
    // Present the Document View Controller for the new newly created document
    presentDocument(at: destinationURL)
  }
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
  }
  
  // MARK: Document Presentation
  
  func presentDocument(at documentURL: URL) {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let navController = storyBoard.instantiateViewController(withIdentifier: "NavigationController")
    if let imageGallerieViewController = navController .contents as? ImageGallerieViewController {
      imageGallerieViewController.document = ImageGallerieDocument(fileURL: documentURL )
    }
    present(navController, animated: true)
  }
}

