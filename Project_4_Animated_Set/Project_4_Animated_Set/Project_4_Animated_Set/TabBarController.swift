//
//  TabBarViewController.swift
//  Project_5_Animated_Set
//
//  Created by Viktor on 18.08.2022.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    viewControllers = [
      createViewController(identifier: "SetViewController", title: "Set", image: .actions),
      createViewController(identifier: "ConcentrationViewController",title: "Concentraion", image: .add)
    ]
    
  
  }
  
  func createViewController(identifier: String, title: String, image: UIImage) -> UIViewController {
    var viewController = UIViewController()
    if identifier == "SetViewController" {
      viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier) as SetViewController
    } else if identifier == "ConcentrationViewController" {
      viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier) as ConcentrationViewController
    }
  
    
      viewController.tabBarItem.title = title
      viewController.tabBarItem.image = image
    return viewController
   
  }
  
}
