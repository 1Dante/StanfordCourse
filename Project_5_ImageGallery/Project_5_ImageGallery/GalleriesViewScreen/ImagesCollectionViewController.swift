//
//  ImagesCollectionViewController.swift
//  Project_5_ImageGallery
//
//  Created by Victor on 02.06.2022.
//

import UIKit

class ImagesCollectionViewController: UIViewController, ImageURLDelegate {
  
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  var images: [Image] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagesCollectionView.dataSource = self
    imagesCollectionView.delegate = self
    imagesCollectionView.dragDelegate = self
    imagesCollectionView.dropDelegate = self
    ImageGaleriesListViewController.delegate = self
    imagesCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:))))
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

extension ImagesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as? ImagesCollectionViewCell
    guard let cell = cell else { return UICollectionViewCell() }
    if let imageURL = images[indexPath.item].url
    {
      cell.activityIndicator.startAnimating()
      DispatchQueue.main.async {
        if let data = try? Data(contentsOf: imageURL) {
          cell.imageView.image = UIImage(data: data)         
        }
        cell.activityIndicator.stopAnimating()
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let fullImageViewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController
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
        as? ImagesCollectionViewCell,
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

extension ImagesCollectionViewController: UICollectionViewDropDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate {
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
                Image(url: imageURL!,
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
