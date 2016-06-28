//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Jottie Brerrin on 6/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Timeline view controller")
    
    self.tabBarController?.delegate = self
  }
  
}

//MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
  func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
    print("uh oh!")
    if (viewController is PhotoViewController) {
      print("Take photo")
      return false
    }
    return true
  }
}