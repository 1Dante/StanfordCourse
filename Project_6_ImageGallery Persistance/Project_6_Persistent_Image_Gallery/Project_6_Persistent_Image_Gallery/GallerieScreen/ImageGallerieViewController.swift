//
//  ImageGallerieViewController.swift
//  Project_6_Persistent_Image_Gallery
//
//  Created by Viktor on 01.07.2022.
//


import UIKit

class ImageGallerieViewController: UIViewController {
  
  
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  var images: [Picture] = []
  var imageCacheRepositury = ImageCacheRepository()
  var isReloaded = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagesCollectionView.dataSource = self
    imagesCollectionView.delegate = self
    imagesCollectionView.dragDelegate = self
    imagesCollectionView.dropDelegate = self
    imagesCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:))))
    imagesCollectionView.dragInteractionEnabled = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    document?.open() { success in
      if success {
        self.title = self.document?.localizedName
        if self.document?.image != nil {
          self.images = (self.document?.image)!
          DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
          }
        }
      }
    }
  }
  
  var document: ImageGallerieDocument?
  private func saveDocument(_ sender: UIBarButtonItem? = nil) {
    if !images.isEmpty {
      document?.image = images
      if document?.image != nil {
        document?.updateChangeCount(.done )
      }
    }
  }
  
  @IBAction func done(_ sender: UIBarButtonItem) {
    saveDocument()
    if document?.image != nil {
      if let url = images.last?.url {
        document?.thumbnail = imageCacheRepositury.getImage(imageURL: url, downloadedImageCompletion: {_ in })
      }
    }
    dismiss(animated: true) {
      self.document?.close()
    }
  }
  
  
  
  private var scale: CGFloat = 1 {
    didSet {
      imagesCollectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  @objc func zoom(_ gesture: UIPinchGestureRecognizer) {
    if gesture.state == .changed {
      scale *= gesture.scale
      gesture.scale = 1.0
    }
  }
  
  
  private var boundsCollectionWidth: CGFloat  {return (imagesCollectionView.bounds.width)}
  private var gapItems: CGFloat  {return (flowLayout?.minimumInteritemSpacing)! *
    CGFloat((3.0 - 1.0))}
  private var gapSections: CGFloat  {return (flowLayout?.sectionInset.right)! * 2.0}
  
  var flowLayout: UICollectionViewFlowLayout? {
    return imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  private var predifinedWidth: CGFloat {
    let width = floor((boundsCollectionWidth - gapItems - gapSections)
                      / CGFloat(3.0)) * scale
    return  min (max (width , boundsCollectionWidth * 0.03),
                 boundsCollectionWidth)
  }
}

extension ImageGallerieViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as? ImageGallerieViewCell
    guard let cell = cell else { return UICollectionViewCell() }
    
    cell.activityIndicator.startAnimating()
    
    cell.imageView.image = self.imageCacheRepositury.getImage(imageURL: self.images[indexPath.item].url, downloadedImageCompletion: { isImageDownloaded in
      if isImageDownloaded {
        DispatchQueue.main.async {
          if !self.isReloaded {
            collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
            self.isReloaded = true
          }
          cell.activityIndicator.stopAnimating()
        }
      }
    })
    
    cell.activityIndicator.hidesWhenStopped = true
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let fullImageViewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
    fullImageViewContoller.imageURL = images[indexPath.item].url
    navigationController?.pushViewController(fullImageViewContoller, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = predifinedWidth
    let aspectRatio = CGFloat(images[indexPath.row].aspectRatio)
    return CGSize(width: predifinedWidth, height: width / aspectRatio)
  }
  
  private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
    if let itemCell = imagesCollectionView?.cellForItem(at: indexPath)
        as? ImageGallerieViewCell,
       let image = itemCell.imageView.image {
      let dragItem =
      UIDragItem(itemProvider: NSItemProvider(object: image))
      dragItem.localObject = indexPath
      return [dragItem]
    }   else {
      return []
    }
  }
}

extension ImageGallerieViewController: UICollectionViewDropDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate {
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    return UICollectionViewDropProposal(operation: .copy)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
    for item in coordinator.items {
      if let sourceIndexPath = item.sourceIndexPath {
        collectionView.performBatchUpdates {
          let image = images.remove(at: sourceIndexPath.item)
          images.insert(image, at: destinationIndexPath.item)
          collectionView.deleteItems(at: [sourceIndexPath])
          collectionView.insertItems(at: [destinationIndexPath])
        }
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
      } else {
        var imageURL: URL?
        var aspectRatio: Double?
        isReloaded = false
        
        item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) {
          (provider, error) in
          DispatchQueue.main.async {
            if let image = provider as? UIImage {
              aspectRatio = Double(image.size.width) /
              Double(image.size.height)
            }
          }
        }
        
        item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) {
          (provider, error) in
          DispatchQueue.main.async {
            if let url = provider as? URL {
              imageURL = url.imageURL
            }
            if imageURL != nil, aspectRatio != nil {
              self.images.insert(
                Picture(url: imageURL!,
                        aspectRatio: aspectRatio!),
                at: destinationIndexPath.item)
              collectionView.insertItems(at: [destinationIndexPath])
            }
          }
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    return dragItems(at: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    guard session.items.count == 1 else {
      return UICollectionViewDropProposal(operation: .cancel)
    }
    if collectionView.hasActiveDrag{
      return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    } else {
      return UICollectionViewDropProposal(operation: .copy,
                                          intent: .insertAtDestinationIndexPath)
    }
  }
}
