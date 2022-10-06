//
//  ImageGaleriesListViewController.swift
//  Project_5_ImageGallery
//
//  Created by Victor on 02.06.2022.
//

import UIKit

protocol ImageURLDelegate { }

class ImageGaleriesListViewController: UIViewController {
  
  @IBOutlet weak var galeriesListTableView: UITableView!
  
  var galeries: [String] = []
  var deletedGaleries: [String] = []
  
  static var delegate: ImageURLDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    // Do any additional setup after loading the view.
  }
  
  private func setup() {
    galeriesListTableView.dataSource = self
    galeriesListTableView.delegate = self
    galeriesListTableView.reloadData()
    if #available(iOS 15.0, *) {
      galeriesListTableView.sectionHeaderTopPadding = 100
    }
  }
  
  @IBAction func addBarButtonIItem(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Add Galeries", message: "Enter name: ", preferredStyle: .alert)
    alertController.addTextField()
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      let textField = alertController.textFields![0]
      if let text = textField.text {
        self.galeries.append(text)
      }
      self.galeriesListTableView.reloadData()
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    self.present(alertController, animated: true)
  }
  
  @objc func doubleTap(recognizer: UITapGestureRecognizer) {
    if recognizer.state == .ended {
      let tapLocation = recognizer.location(in: galeriesListTableView)
      if let tapIndexPath = galeriesListTableView.indexPathForRow(at: tapLocation) {
        if let cell = galeriesListTableView.cellForRow(at: tapIndexPath) as? ImagesGalleriesTableViewCell {
          cell.textField.isUserInteractionEnabled = true
          cell.textField.becomeFirstResponder()
          cell.editText = { text in
            self.galeries[tapIndexPath.row] = text
          }
        }
      }
    }
  }
}

extension ImageGaleriesListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return galeries.count
    } else if section == 1 {
      return deletedGaleries.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
      return "Recently deleted"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GaleriesCell", for: indexPath) as? ImagesGalleriesTableViewCell
    guard let cell = cell else { return UITableViewCell() }
    if !galeries.isEmpty && indexPath.section == 0 {
      let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
      doubleTap.numberOfTapsRequired = 2
      self.galeriesListTableView.addGestureRecognizer(doubleTap)
      cell.textField.text = galeries[indexPath.row]
      return cell
    } else if !deletedGaleries.isEmpty && indexPath.section == 1 {
      cell.textField.text = deletedGaleries[indexPath.row]
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let imagesCollectionVC = ImageGaleriesListViewController.delegate as? ImagesCollectionViewController,
       let detailNavigationController = imagesCollectionVC.navigationController {
      splitViewController?.showDetailViewController(detailNavigationController, sender: self)
      imagesCollectionVC.navigationItem.title = galeries[indexPath.row]
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if indexPath.section == 0 && editingStyle == .delete {
      deletedGaleries.append(galeries[indexPath.row])
      galeries.remove(at: indexPath.row)
    } else if indexPath.section == 1 && editingStyle == .delete {
      deletedGaleries.remove(at: indexPath.row)
    }
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if indexPath.section == 1 {
      let contextualAction = UIContextualAction(style: .normal, title: "Restore Galeries") { _, _, _ in
        self.galeries.append(self.deletedGaleries[indexPath.row])
        self.deletedGaleries.remove(at: indexPath.row)
        tableView.reloadData()
      }
      return UISwipeActionsConfiguration(actions: [contextualAction])
    }
    return nil
  }
}
